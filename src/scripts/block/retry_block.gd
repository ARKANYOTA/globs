@tool
extends Area2D


var size_pixels: Vector2
var is_collected = false

@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16
@onready var collision_shape = $CollisionShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = size_pixels
	collision_shape.position = Vector2(0,0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area:Area2D) -> void:
	if is_collected:
		return
	if !(area is Block and area.is_main_character):
		return
		
	is_collected = true
	LevelData.reload_scene()


# func _on_body_entered(body:Node2D) -> void:
# 	if is_collected:
# 		return
	
# 	is_collected = true
# 	LevelData.reload_scene()
