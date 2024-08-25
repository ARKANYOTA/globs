extends Node2D
class_name Main

@onready var game = $Game

var paused = false
var clicked = false

func _ready():
	if PauseMenuAutoload.game_gui:
		PauseMenuAutoload.game_gui.hide_gui()
	PauseMenuAutoload.can_pause = false

# Quitting 
func quit():
	get_tree().quit()


func _on_activation_button_pressed():
	if not clicked:
		clicked = true
		PauseMenuAutoload.can_pause = true
		SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/level_select.tscn", false)
