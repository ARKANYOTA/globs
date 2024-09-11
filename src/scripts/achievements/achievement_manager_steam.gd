extends AchievementManager

func _ready():
	pass


func grant(achievement_name: String) -> bool:
	if not GameManager.steam_interface:
		return false
	if not achievement_exists(achievement_name):
		return false

	return GameManager.steam_interface.grant_achievement("ACH_TEST_01")
	
func revoke(achievement_name:	String) -> bool:
	if not GameManager.steam_interface:
		return false
	if not achievement_exists(achievement_name):
		return false
	
	return GameManager.steam_interface.revoke_achievement(achievement_name)