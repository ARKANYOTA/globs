extends AchievementManager
class_name AchievementManagerGooglePlay

var google_play_id_to_achievement = _generate_google_play_id_to_achievement()

func _ready():
	pass


func _generate_google_play_id_to_achievement():
	var dict = {}

	for ach_id in achievements:
		var ach = achievements[ach_id]
		dict[ach["google_play_id"]] = ach
	
	return dict


func grant(achievement_name: String) -> bool:
	super(achievement_name)
	
	print("Granting ", achievement_name, "... (pre-conditions)")
	if not GameManager.google_play_interface:
		return false
	if not achievement_exists(achievement_name):
		return false

	var ach: Dictionary = get_achievement(achievement_name)
	if ach.is_empty():
		return false

	print("Granting ", achievement_name, "...")
	return GameManager.google_play_interface.grant_achievement(ach["google_play_id"])


func revoke(achievement_name: String) -> bool:
	return false
