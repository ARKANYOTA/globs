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

func _input(event):
	if event.is_action_pressed("left_click") and not clicked:
		clicked = true
		PauseMenuAutoload.can_pause = true
		SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/world_select/world_select.tscn", false)
