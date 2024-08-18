extends Node

var cursor = load("res://assets/images/ui/cursor_big.png")

func win():
	LevelData.increment_level_and_change_scene()

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)

func _process(delta):
	pass

func before_scene_change():
	BlockManagerAutoload.blocks.clear()
