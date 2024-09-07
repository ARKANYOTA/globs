extends Node2D

var selected_level = 1

@export var button_list : Array[LevelButton] = []
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	pass

func _process(delta):
	#transition_audio.play()
	animation.play("background")
	#await animation.animation_finished
	pass

# on input event
func _input(event):
	if event.is_action_pressed("ui_right"):
		selected_level = max(LevelData.level, selected_level + 1)
	elif event.is_action_pressed("ui_left"):
		selected_level = min(1, selected_level - 1)
	elif event.is_action_pressed("ui_select"):
		LevelData.level = selected_level
		#get_tree().change_scene(LevelData.levels[selected_level].scene)
