extends Node
class_name AchievementManager

var achievements: Dictionary = {
	"ACH_COMPLETE_WORLD_1": {achieved = false, hidden = false},
	"ACH_COMPLETE_WORLD_2": {achieved = false, hidden = false},
	"ACH_COMPLETE_WORLD_3": {achieved = false, hidden = false},
	"ACH_COMPLETE_WORLD_4": {achieved = false, hidden = false},
	"ACH_COMPLETE_MAIN_GAME": {achieved = false, hidden = false},
	"ACH_WAKEY_WAKEY": {achieved = false, hidden = false},
	"ACH_GLOBS_IN_VOID_5_TIMES": {achieved = false, hidden = false},
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
