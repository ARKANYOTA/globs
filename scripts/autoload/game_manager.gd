extends Node

# Load the custom images for the mouse cursor.
var cursor = load("res://assets/images/ui/cursor_big.png")

func win():
	LevelData.increment_level_and_change_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
