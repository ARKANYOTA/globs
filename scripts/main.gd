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
	if Input.is_action_just_pressed("removeme"):
		var block = $Game/ScalableBlock
		block.dimensions = Vector2(block.dimensions.x + 4, 16)
		print(block.position)

# Quitting 
func quit():
	get_tree().quit()
