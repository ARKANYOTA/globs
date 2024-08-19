extends Node

var cursor = load("res://assets/images/ui/cursor_big.png")
var cursor_click = load("res://assets/images/ui/cursor_click_big.png")

func win():
	LevelData.increment_level_and_change_scene()

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(cursor_click, Input.CURSOR_IBEAM)

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_custom_mouse_cursor(cursor_click)
	else:
		Input.set_custom_mouse_cursor(cursor)

func before_scene_change():
	BlockManagerAutoload.blocks.clear()
	BlockManagerAutoload.reset()
