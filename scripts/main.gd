extends Node2D
class_name Main

@onready var menu_manager: MenuManager = $MenuManager
@onready var pause_menu = $MenuManager/PauseMenu
@onready var game = $Game

var paused = false

func _ready():
	pass

func _process(delta):
	pass

# Quitting 
func quit():
	get_tree().quit()
