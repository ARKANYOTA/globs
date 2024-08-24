extends Node2D

class_name ScrollComponent

var is_dragging = false
var mouse_click_position = Vector2()
var mouse_unclick_position = Vector2()
var delta_max = 32

@export var world_select : WorldSelect

func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
			mouse_click_position = event.position
		else:
			is_dragging = false
			mouse_unclick_position = event.position
			if (mouse_click_position.x - mouse_unclick_position.x) > delta_max:
				world_select.increment_world_index(false)
			elif (mouse_click_position.x - mouse_unclick_position.x) < -delta_max:
				world_select.decrement_world_index(false)
			else:
				world_select.restore_position()
			pass
	elif event is InputEventMouseMotion:
		if is_dragging:
			var delta = event.relative
			for child in get_children():
				child.position.x += delta.x
			pass
