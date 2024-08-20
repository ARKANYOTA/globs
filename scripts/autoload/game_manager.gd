extends Node

var cursor = load("res://assets/images/ui/cursor_big.png")
var cursor_click = load("res://assets/images/ui/cursor_click_big.png")

var is_fullscreen := false

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

func on_restart():
	pass

func before_scene_change():
	BlockManagerAutoload.blocks.clear()
	BlockManagerAutoload.reset()

func toggle_fullscreen():
	is_fullscreen = not is_fullscreen
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
