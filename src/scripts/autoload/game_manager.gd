extends Node

var cursor = preload("res://assets/images/ui/cursor_big.png")
var cursor_click = preload("res://assets/images/ui/cursor_click_big.png")

var is_fullscreen := false

func win():
	LevelData.increment_level_and_change_scene()

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(cursor_click, Input.CURSOR_IBEAM)

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("left_click"):
		Input.set_custom_mouse_cursor(cursor_click)
	
	if event.is_action_released("left_click"):
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
