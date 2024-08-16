extends Area2D
class_name ClickArea

var is_hovered := false

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false
