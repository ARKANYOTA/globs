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
		$NinePatchRect2.position = -size_pixels/2
		$NinePatchRect2.size = size_pixels

		#size = value
		#size_pixels = Vector2(value) * 16
		#nine_patch.position = Vector2(0, 0)
		#nine_patch.size = Vector2(value) * 16
		#collision_shape.position = Vector2(0, 0)
		#collision_shape.shape.size = Vector2(value)*16

func direction_to_rotation(direction: Block.Direction) -> float:
	if direction == Block.Direction.LEFT:
		return PI
	elif direction == Block.Direction.RIGHT:
		return 0
	elif direction == Block.Direction.UP:
		return -PI/2
	elif direction == Block.Direction.DOWN:
		return PI/2
	return 0

@export var gravity_axis = Block.Direction.DOWN:
	set(value):
		$NinePatchRect2.rotation = direction_to_rotation(value) - PI/2
		
@export var is_effect_permanent = false

func _ready():
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = Vector2(size_pixels) - Vector2(2,2)
	collision_shape.position = Vector2(0,0)

func _on_area_entered(area):
	if not area is Block:
		return
	area.enter_gravity_zone(gravity_axis, is_effect_permanent)

func _on_area_exited(area):
	if is_effect_permanent:
		return
		
	if not area is Block:
		return
		
	area.exit_gravity_zone(gravity_axis)

	pass # Replace with function body.
