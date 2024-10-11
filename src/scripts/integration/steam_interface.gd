extends Node

var is_enabled: bool = false
var steam_initialized_correctly: bool = false

func initialize() -> bool:
	var initialize_response: Dictionary = Steam.steamInitEx(true, GameManager.STEAM_APP_ID)
	_print("SteamInterface: GodotSteam returned code %d: \"%s\"" % [initialize_response["status"], initialize_response["verbal"]])
	# Return codes:
    # 0 - Successfully initialized
    # 1 - Some other failure
    # 2 - We cannot connect to Steam, steam probably isn't running
    # 3 - Steam client appears to be out of date

	steam_initialized_correctly = initialize_response["status"] == 0
	is_enabled = steam_initialized_correctly
	if not is_enabled:
		return false
	
	# is_on_steam_deck = Steam.isSteamRunningOnSteamDeck()
    # is_online = Steam.loggedOn()
    # is_owned = Steam.isSubscribed()
    # steam_id = Steam.getSteamID()
    # steam_username = Steam.getPersonaName()

	Steam.current_stats_received.connect(_on_steam_stats_ready)
	return true

func _print(msg):
	print("[SteamInterface] ", msg)

func _process(_delta):
	if not is_enabled:
		return
	
	Steam.run_callbacks()

func _on_steam_stats_ready(game_id: int, result: int, user_id: int):
	_print("Steam stats ready with code %s for: game_id = %s, user_id = %s" % [result, game_id, user_id])
	if GameManager.achievement_manager:
		load_achievements(GameManager.achievement_manager.achievements)


func achievement_exists(value: String) -> bool:
	var this_achievement: Dictionary = Steam.getAchievement(value)
	return this_achievement['ret']

# Process achievements
func is_achievement_achieved(value: String) -> bool:
	var this_achievement: Dictionary = Steam.getAchievement(value)
	assert(this_achievement['ret'], "Attempt to access non-existant achievement \"%s\"")

	return this_achievement['achieved']

func grant_achievement(value: String) -> bool:
	var success = Steam.setAchievement(value)
	if success:
		Steam.storeStats()
	return success

func revoke_achievement(value: String) -> bool:
	var success = Steam.clearAchievement(value)
	if success:
		Steam.storeStats()
	return success

func load_achievements(achievements: Dictionary) -> void:
	var count = 0
	var count_invalid = 0
	for ach in achievements:
		var exists := achievement_exists(ach)
		var achieved := false
		if exists:
			achievements[ach]["achieved"] = is_achievement_achieved(ach) 
			count += 1
		else:
			achievements[ach] = false
			count_invalid += 1
	
	_print("Finished loading %s achievements (%s invalid)" % [count, count_invalid])