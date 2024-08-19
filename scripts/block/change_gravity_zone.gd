@tool
extends Area2D


@onready var nine_patch = $NinePatchRect
@onready var collision_shape = $CollisionShape2D

var size_pixels: Vector2
@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16
		$NinePatchRect.position = -size_pixels/2
		$NinePatchRect.size = size_pixels

		#size = value
		#size_pixels = Vector2(value) * 16
		#nine_patch.position = Vector2(0, 0)
		#nine_patch.size = Vector2(value) * 16
		#collision_shape.position = Vector2(0, 0)
		#collision_shape.shape.size = Vector2(value)*16


@export var gravity_axis = Block.Direction.DOWN
@export var is_effect_permanent = false

func _ready():
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = Vector2(size_pixels) - Vector2(2,2)
	collision_shape.position = Vector2(0,0)

func _on_area_entered(area):
	if not area is Block:
		return
	area.enter_gravity_zone(gravity_axis)

func _on_area_exited(area):
	if is_effect_permanent:
		return
		
	if not area is Block:
		return
		
	area.exit_gravity_zone()

	pass # Replace with function body.
