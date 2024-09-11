extends Node
class_name AchievementManager

var achievements: Dictionary = {
	"ACH_TEST_01": {achieved = false, hidden = false},
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