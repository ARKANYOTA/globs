extends Node
class_name AchievementManager

var achievements: Dictionary = {
	"ACH_COMPLETE_WORLD_1":      _new_achievement("CgkIqufXsuUZEAIQAQ"),
	"ACH_COMPLETE_WORLD_2":      _new_achievement("CgkIqufXsuUZEAIQAg"),
	"ACH_COMPLETE_WORLD_3":      _new_achievement("CgkIqufXsuUZEAIQAw"),
	"ACH_COMPLETE_WORLD_4":      _new_achievement("CgkIqufXsuUZEAIQBA"),
	"ACH_COMPLETE_MAIN_GAME":    _new_achievement("CgkIqufXsuUZEAIQBQ"),
	"ACH_COMPLETE_100_PERCENT":  _new_achievement("CgkIqufXsuUZEAIQBg"),
	"ACH_SECRET_WORLD_SELECT":   _new_achievement("CgkIqufXsuUZEAIQBw"),
	"ACH_GLOBS_IN_VOID_5_TIMES": _new_achievement("CgkIqufXsuUZEAIQCA"),
	"ACH_WAKEY_WAKEY":           _new_achievement("CgkIqufXsuUZEAIQCQ"),
}

func _new_achievement(google_play_id: String = "", hidden: bool = false):
	return {
		name = "",
		description = "",
		achieved = false, 
		hidden = hidden,
		google_play_id = google_play_id,
	}

func _init():
	pass

func achievement_exists(achievement_name: String) -> bool:
	return achievements.has(achievement_name)

func grant(achievement_name: String) -> bool:
	return false

func revoke(achievement_name: String) -> bool:
	return false

func revoke_all() -> void:
	for ach in achievements:
		revoke(ach)
