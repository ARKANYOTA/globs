extends Node

var is_enabled: bool = false
var steam_initialized_correctly: bool = false

var _sign_in_retries := 5

func initialize() -> bool:
	_print("Entered initialize")
	
	_print("Checking 'not GodotPlayGameServices.android_plugin'")
	if not GodotPlayGameServices.android_plugin:
		_print("Android plugin Not Found! Features may not work properly.")

	
	SignInClient.user_authenticated.connect(_on_user_autheticated)

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

# func grant_achievement(value: String) -> bool:
# 	return false

# func revoke_achievement(value: String) -> bool:
# 	return false

# func load_achievements(achievements: Dictionary) -> void:
# 	var count = 0
# 	var count_invalid = 0
# 	for ach in achievements:
# 		var exists := achievement_exists(ach)
# 		var achieved := false
# 		if exists:
# 			achievements[ach]["achieved"] = is_achievement_achieved(ach) 
# 			count += 1
# 		else:
# 			achievements[ach] = false
# 			count_invalid += 1
	
# 	print("Finished loading %s achievements (%s invalid)" % [count, count_invalid])