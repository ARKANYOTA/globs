extends Control

class_name LevelButton

@export var level: int = 0
@onready var button = $Button
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_label(LevelData.levels[level].name)
	if level > LevelData.level:
		print("Locked")
		button.icon = preload("res://assets/images/ui/locked_button.png")
	else:
		print("Unlocked")
		button.icon = preload("res://assets/images/ui/button.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_label(string: String) -> void:
	label.text = str(string)

func _on_button_pressed() -> void:
	if level > LevelData.level:
		return
	var scene = LevelData.levels[level].scene
	SceneTransitionAutoLoad.change_scene_with_transition(scene)
	# get_tree().change_scene_to_file(scene)
	pass # Replace with function body.
