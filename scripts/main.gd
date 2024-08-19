extends Node2D
class_name Main

@onready var menu_manager: MenuManager = $MenuManager
@onready var pause_menu = $MenuManager/PauseMenu
@onready var game = $Game

var paused = false
var clicked = false

func _ready():
	PauseMenuAutoload.can_pause = false

func _input(event):
	if not clicked and event.is_action_pressed("left_click"):
		clicked = true
		PauseMenuAutoload.can_pause = true
		SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/level_select.tscn", false)

# Quitting 
func quit():
	get_tree().quit()
