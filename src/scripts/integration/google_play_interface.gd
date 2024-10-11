extends Node

var is_enabled: bool = false
var steam_initialized_correctly: bool = false

var _sign_in_retries := 1

func initialize() -> bool:
	_print("Entered initialize")
	
	_print("Checking 'not GodotPlayGameServices.android_plugin'")
	if not GodotPlayGameServices.android_plugin:
		_print("Android plugin Not Found! Features may not work properly.")

	SignInClient.user_authenticated.connect(_on_user_autheticated)

	if GameManager.achievement_manager and GameManager.achievement_manager is AchievementManagerGooglePlay:
		AchievementsClient.achievements_loaded.connect(_on_achievements_loaded)
		AchievementsClient.load_achievements(true)

	_print("Finished initialization")
	is_enabled = true
	return true

func _print(text: String):
	print("[GooglePlayInterface] ", text)

func _process(_delta):
	if not is_enabled:
		return
	
func popup_is_authenticated() -> void:
	if not is_enabled:
		return
	
	return SignInClient.is_authenticated()


func _on_user_autheticated(is_authenticated: bool):
	_print("user_authenticated signal called")
	if _sign_in_retries > 0 and not is_authenticated:
		_print("Trying to sign in!")
		SignInClient.sign_in()
		_sign_in_retries -= 1
	
	if _sign_in_retries == 0:
		_print("Sign in attemps expired!")
	
	if is_authenticated:
		_print("Autheticated!")

#################	
# Achievements
#################

func open_achievements_menu():
	_print("open_achievements_menu 1")
	if not is_enabled:
		return

	_print("open_achievements_menu 2")
	AchievementsClient.show_achievements()

# func achievement_exists(value: String) -> bool:
# 	return false

# # Process achievements
# func is_achievement_achieved(value: String) -> bool:
# 	return false

func grant_achievement(achievement_id: String) -> bool:
	AchievementsClient.unlock_achievement(achievement_id)
	return true

func revoke_achievement(value: String) -> bool:
	return false

func _on_achievements_loaded(remote_achievements: Array[AchievementsClient.Achievement]):
	if not GameManager.achievement_manager or GameManager.achievement_manager is not AchievementManagerGooglePlay:
		return 

	var loaded_achievements = {}
	
	var google_play_id_to_achievement = GameManager.achievement_manager.google_play_id_to_achievement

	for remote_achievement in remote_achievements:
		if google_play_id_to_achievement.has(remote_achievement.achievement_id):
			var achievement = google_play_id_to_achievement[remote_achievement.achievement_id] 
			loaded_achievements[achievement["id"]] = {
				achieved = (remote_achievement.state == AchievementsClient.State.STATE_UNLOCKED)
			}
		
	GameManager.achievement_manager.load_achievements(loaded_achievements)


# func _on_steam_stats_ready(game_id: int, result: int, user_id: int):
# 	_print("Steam stats ready with code %s for: game_id = %s, user_id = %s" % [result, game_id, user_id])
# 	if GameManager.achievement_manager:
# 		load_achievements(GameManager.achievement_manager.achievements)
