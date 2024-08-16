extends Node2D
class_name Main

@onready var menu_manager: MenuManager = $MenuManager
@onready var pause_menu = $MenuManager/PauseMenu
@onready var game = $Game

var paused = false

func _ready():
	menu_manager.visible = true
	menu_manager.exit_menu()

func _process(delta):
	pass

# Quitting 
func quit():
	get_tree().quit()
