# https://www.peanuts-code.com/en/tutorials/gd0022_implement_game_center/
# https://www.peanuts-code.com/en/tutorials/gd0021_game_center_plugin/
extends AchievementManager
class_name AchievementManagerGamecenter

# Game Center plugin
var game_center = null

func _ready():
	if OS.get_name() == "iOS":
		if Engine.has_singleton("GameCenter"):
			print("Found GameCenter plugin")
			game_center = Engine.get_singleton("GameCenter")
			var res = game_center.authenticate()
			print("Authentication: ", res)
		else:
			print("There is no GameCenter plugin")

func grant(achievement_name: String) -> bool:
	if not game_center:
		return false

	if not game_center.is_authenticated():
		print("not authenticated, authenticating again")
		game_center.authenticate()

	var data = {"name": achievement_name, "progress": 100.0}
	print("New Achievement data: ", data)
	var res = game_center.award_achievement(data)
	print("Update Achievement response: " + str(res))
	return true
	
func revoke(achievement_name: String) -> bool:
	return false

func open_achievements_menu():
	var res = game_center.show_game_center({ "view": "achievements" })
	print("open achievements menu ", res)
	return

"""
func update_achievement(item_name:String, progress:float):
	if not game_center:
		return

	if not game_center.is_authenticated():
		print("not authenticated, authenticating again")
		game_center.authenticate()

	var data = {"name": item_name, "progress": progress}
	print("New Achievement data: ", data)
	var res = game_center.award_achievement(data)
	print("Update Achievement response: " + str(res))
"""
