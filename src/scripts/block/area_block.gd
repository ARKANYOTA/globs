@tool

extends Area2D


var size_pixels: Vector2
var is_collected = false
signal on_glob_touched
signal on_main_character_touched

@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16
		$CollisionShape.shape = $CollisionShape.shape.duplicate()
		$CollisionShape.shape.size = size_pixels
		$CollisionShape.position = Vector2(0,0)

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_area_entered(area:Area2D) -> void:
	if is_collected:
		return
	if !(area is Block):
		return
	if area.is_main_character:
		emit_signal("on_main_character_touched")
	emit_signal("on_glob_touched")