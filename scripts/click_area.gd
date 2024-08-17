@tool
extends Area2D
class_name ClickArea

signal clicked
signal start_drag
signal dragging
signal end_drag

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
var is_held := false

func _input(event):
	if Engine.is_editor_hint():
		return
	
	if is_hovered and event.is_action_pressed("left_click"):
		print("press")
		clicked.emit()
		start_drag.emit()
		is_held = true
	
	if is_held and event.is_action_released("left_click"):
		print("release")
		is_held = false
		end_drag.emit()

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if is_held:
		dragging.emit()

func _on_mouse_entered():
	if Engine.is_editor_hint():
		return
	
	is_hovered = true

func _on_mouse_exited():
	if Engine.is_editor_hint():
		return
	
	is_hovered = false
