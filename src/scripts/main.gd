extends Node2D
class_name Main

@onready var game = $Game

var credit_names = ["ArkanYota", "Notgoyome", "Strochnis", "Theobosse", "Yolwoocle"]

var paused = false
var clicked = false

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

func _randomize_credits():
	var credits: Label = %CreditsText
	if not credits:
		return

	credit_names.shuffle()
	credits.text = credits.text.format(credit_names)

# Quitting 
func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("left_click") and not clicked:
		clicked = true
		PauseMenuAutoload.can_pause = true
		SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/world_select/world_select.tscn", false)
