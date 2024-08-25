extends Control

class_name LevelButton

@export var level: int = 0
@onready var button = $Button
@onready var label = $Label

var texture_normal = preload("res://assets/images/ui/button.png")
var texture_hover = preload("res://assets/images/ui/button_hover.png")
var texture_pressed = preload("res://assets/images/ui/button_clicked.png")
var texture_locked = preload("res://assets/images/ui/locked_button.png")

var is_locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_label(LevelData.levels[level].name)
	is_locked = true
	button.icon = texture_locked
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func unlock() -> void:
	is_locked = false
	button.icon = texture_normal
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func change_label(string: String) -> void:
	label.text = str(string)

func _on_button_pressed() -> void:
	if max(level, 0) > LevelData.level:
		return
	button.icon = texture_pressed
	var scene = LevelData.levels[level].scene
	LevelData.current_level = level
	SceneTransitionAutoLoad.change_scene_with_transition(scene)
	# get_tree().change_scene_to_file(scene)
	pass # Replace with function body.


func _on_button_mouse_entered():
	if is_locked:
		return
	button.icon = texture_hover


func _on_button_mouse_exited():
	if is_locked:
		return
	button.icon = texture_normal
