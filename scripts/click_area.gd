@tool
extends Area2D
class_name ClickArea

signal clicked

@export var size: Vector2i:
	set(value):
		size = value
		var shape = $ClickAreaCollisionShape
		if shape:
			$ClickAreaCollisionShape.shape.size = Vector2(value)

@export var debug_color: Color = Color(1, 0, 1, 0.5):
	set(value):
		debug_color = value
		var shape = $ClickAreaCollisionShape
		if shape:
			$ClickAreaCollisionShape.debug_color = value

var is_hovered := false

func _input(event):
	if Engine.is_editor_hint():
		return
	
	if is_hovered and event.is_action_pressed("left_click"):
		clicked.emit()

func _on_mouse_entered():
	if Engine.is_editor_hint():
		return
	
	is_hovered = true

func _on_mouse_exited():
	if Engine.is_editor_hint():
		return
	
	is_hovered = false
