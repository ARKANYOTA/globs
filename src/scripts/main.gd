extends Node2D
class_name Main

@onready var game = $Game

var paused = false
var clicked = false

var credits_names

func _ready():
	if PauseMenuAutoload.game_gui:
		PauseMenuAutoload.game_gui.show_title_gui()
	PauseMenuAutoload.can_pause = false
	if OS.has_feature("web_ios") or OS.has_feature("web_macos"):
		$CanvasLayer/AppleWarn.show()
	
	_set_version_text()
	_randomize_credits()

	if GameManager.load_option("misc", "is_logo_golden", false):
		%MainScreenLogo.play("logo_golden")
		%MainScreenSparkles.show()
	else:
		%MainScreenLogo.play("logo_default")
		%MainScreenSparkles.hide()

func _set_version_text():
	if ProjectSettings.has_setting("application/config/version"):
		%VersionText.text = "v" + ProjectSettings.get_setting("application/config/version")
	else:
		%VersionText.text = ""


func _process(delta):
	var credits: Label = %CreditsText
	if credits:
		credits.text = tr("CREDITS_A_GAME_BY_LIST").format(credits_names)

func _randomize_credits():
	credits_names = GameManager.get_randomized_credits()
	var credits: Label = %CreditsText
	if not credits:
		return

# Quitting 
func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("left_click") and not clicked:
		clicked = true
		PauseMenuAutoload.can_pause = true
		SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/world_select/world_select.tscn", false)
