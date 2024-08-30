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
	

@export var is_effect_permanent = false:
	set(value):
		is_effect_permanent = value
		var ninepatch2 = $NinePatchRect2
		if ninepatch2 == null:
			return
		var ninepatch = $NinePatchRect
		if ninepatch == null:
			return

		var permanent_color = 16 if value else 0
		if gravity_axis == Block.Direction.RIGHT:
			ninepatch2.region_rect = Rect2(0,permanent_color,16,16)
		elif gravity_axis == Block.Direction.LEFT:
			ninepatch2.region_rect = Rect2(16,permanent_color,16,16)
		elif gravity_axis == Block.Direction.UP:
			ninepatch2.region_rect = Rect2(32,permanent_color,16,16)
		else:
			ninepatch2.region_rect = Rect2(48,permanent_color,16,16)
		ninepatch.region_rect = Rect2(64,permanent_color,16,16)

@export var gravity_axis = Block.Direction.RIGHT:
	set(value):
		gravity_axis = value
		var ninepatch2 = $NinePatchRect2
		if ninepatch2 == null:
			return

		var permanent_color = 16 if is_effect_permanent else 0
		if value == Block.Direction.RIGHT:
			ninepatch2.region_rect = Rect2(0,permanent_color,16,16)
		elif value == Block.Direction.LEFT:
			ninepatch2.region_rect = Rect2(16,permanent_color,16,16)
		elif value == Block.Direction.UP:
			ninepatch2.region_rect = Rect2(32,permanent_color,16,16)
		else:
			ninepatch2.region_rect = Rect2(48,permanent_color,16,16)

			

func _ready():
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = Vector2(size_pixels) - Vector2(14,14)
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
