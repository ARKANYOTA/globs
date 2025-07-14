extends Node
class_name AchievementManager

const ACHIEVEMENT_FILE_PATH = "user://achievements.cfg"
var achievement_file = ConfigFile.new()
var achievements: Dictionary = _parse_achievements({
	"ACH_COMPLETE_WORLD_1":      _new_achievement("CgkIqufXsuUZEAIQAQ"),
	"ACH_COMPLETE_WORLD_2":      _new_achievement("CgkIqufXsuUZEAIQAg"),
	"ACH_COMPLETE_WORLD_3":      _new_achievement("CgkIqufXsuUZEAIQAw"),
	"ACH_COMPLETE_WORLD_4":      _new_achievement("CgkIqufXsuUZEAIQBA"),
	"ACH_COMPLETE_MAIN_GAME":    _new_achievement("CgkIqufXsuUZEAIQBQ"),
	"ACH_COMPLETE_100_PERCENT":  _new_achievement("CgkIqufXsuUZEAIQBg"),
	"ACH_SECRET_WORLD_SELECT":   _new_achievement("CgkIqufXsuUZEAIQBw"),
	"ACH_GLOBS_IN_VOID_5_TIMES": _new_achievement("CgkIqufXsuUZEAIQCA"),
	"ACH_WAKEY_WAKEY":           _new_achievement("CgkIqufXsuUZEAIQCQ"),
	"ACH_SCARECROW":             _new_achievement("CgkIqufXsuUZEAIQCg"),
})
var granted_achievements = {}

func _new_achievement(google_play_id: String = "", hidden: bool = false):
	return {
		id = "", # Will be set later to its correct value
		name = "",
		description = "",
		achieved = false, 
		hidden = hidden,
		google_play_id = google_play_id,
	}

func _parse_achievements(achievements_input: Dictionary):
	for ach_id in achievements_input:
		achievements_input[ach_id]["id"] = ach_id
	return achievements_input 

func _init():
	pass

func grant_offline_achievements():
	print("Loading and granting offline achievements...")
	
	var err = achievement_file.load(ACHIEVEMENT_FILE_PATH)
	if err != OK:
		print("Error loading achievements file with error", Util.error_to_string(err), ".")
	else:
		var achievement_data = achievement_file.get_value("achievements", "achievements", [])
		granted_achievements = achievement_data
		for ach in achievement_data:
			grant(ach)

func achievement_exists(achievement_name: String) -> bool:
	return achievements.has(achievement_name)

func get_achievement(achievement_name: String) -> Dictionary:
	if not achievement_exists(achievement_name):
		return {}
	return achievements[achievement_name]

func grant(achievement_name: String) -> bool:
	_save_achievement(achievement_name)
	return false

func revoke(achievement_name: String) -> bool:
	return false

func revoke_all() -> void:
	for ach in achievements:
		revoke(ach)

## Loads the given dict into the `achievements` attribute. [br]
## Format for every item in this Dictionary: [br]
## - [code]achieved: bool[/code]
func load_achievements(achievements_to_load: Dictionary):
	var count = 0
	var count_invalid = 0

	for new_ach_id in achievements_to_load:
		var new_ach = achievements_to_load[new_ach_id]
		if achievement_exists(new_ach_id):
			achievements[new_ach_id]["achieved"] = new_ach["achieved"]
			count += 1
		else:
			achievements[new_ach_id]["achieved"] = false
			count_invalid += 1

	print("Finished loading %s achievements (%s invalid)" % [count, count_invalid])
	

func _save_achievement(achievement_name: String):
	granted_achievements[achievement_name] = true
	achievement_file.set_value("achievements", "achievements", granted_achievements)
	achievement_file.save(ACHIEVEMENT_FILE_PATH)
