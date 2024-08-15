extends Node2D
class_name Main

@onready var pause_menu = $MenuCanvasLayer/PauseMenu
@onready var game = $Game

var paused = false

func _ready():
	unpause()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

# Pausing

func toggle_pause():
	if paused:
		unpause()
	else:
		pause()

func pause():
	paused = true
	pause_menu.show()	
	get_tree().set_pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause():
	paused = false
	pause_menu.hide()
	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)	

# Quitting 
func quit():
	get_tree().quit()
