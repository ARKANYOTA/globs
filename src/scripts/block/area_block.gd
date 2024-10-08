@tool
extends Area2D


var size_pixels: Vector2
var is_collected = false
signal on_globs_touched
signal on_main_character_touched
@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16
@onready var collision_shape = $CollisionShape

func _ready() -> void:
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = size_pixels
	collision_shape.position = Vector2(0,0)
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
		return
	emit_signal("on_globs_touched")




# func _on_body_entered(body:Node2D) -> void:
# 	if is_collected:
# 		return
	
# 	is_collected = true
# 	LevelData.reload_scene()
