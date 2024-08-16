@tool
extends CharacterBody2D
class_name Block

enum Direction {
	LEFT, RIGHT, UP, DOWN
}

@export var is_gravity_enabled = true

@export var rotatable: bool = false
@export_range(-360, 360) var angle: float = 0:
	set(value):
		angle = value
		$CollisionShape.rotation_degrees = value
		$Sprite.rotation_degrees = value

var is_hovered := false

@onready var label := $Label

func expand(direction: Direction, amount: int):
	if direction == Direction.RIGHT:
		right_extend_value += amount
	if direction == Direction.LEFT:
		left_extend_value += amount
	if direction == Direction.UP:
		up_extend_value += amount
	if direction == Direction.DOWN:
		down_extend_value += amount

@export_group("Up Extandable")
@export var up_extendable: bool = false
@export var up_extend_range: Vector2i = Vector2i(5, 50)
@export var up_extend_value: float = 5:
	set(value):
		up_extend_value = clamp(value, up_extend_range.x, up_extend_range.y)
		update_dimensions()

@export_group("Down Extandable")
@export var down_extendable: bool = false
@export var down_extend_range: Vector2i = Vector2i(5, 50)
@export var down_extend_value: float = 5:
	set(value):
		down_extend_value = clamp(value, down_extend_range.x, down_extend_range.y)
		update_dimensions()

@export_group("Left Extandable")
@export var left_extendable: bool = false
@export var left_extend_range: Vector2i = Vector2i(5, 50)
@export var left_extend_value: float = 5:
	set(value):
		left_extend_value = clamp(value, left_extend_range.x, left_extend_range.y)
		update_dimensions()

@export_group("Right Extandable")
@export var right_extendable: bool = false
@export var right_extend_range: Vector2i = Vector2i(5, 50)
@export var right_extend_value: float = 5:
	set(value):
		right_extend_value = clamp(value, right_extend_range.x, right_extend_range.y)
		update_dimensions()

func update_dimensions():
	var dim: Vector2 = Vector2(left_extend_value + right_extend_value, 
							   up_extend_value + down_extend_value)
	var collision_shape = $CollisionShape
	var click_area = $ClickArea
	var click_area_collision_shape = $ClickArea/ClickAreaCollisionShape
	var shape = collision_shape.shape
	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = dim
	click_area_collision_shape.shape = shape
	
	# Update position
	var child_pos: Vector2 = Vector2(-left_extend_value + right_extend_value,
									 -up_extend_value   + down_extend_value) / 2
	collision_shape.position = child_pos
	click_area.position = child_pos
	update_sprite_size(child_pos, dim)
	
	

func update_sprite_size(pos, dimensions):
	var sprite: Sprite2D = $Sprite
	
	sprite.position = pos
	
	var sprite_size = sprite.texture.get_size()
	sprite.scale.x = dimensions.x / sprite_size.x
	sprite.scale.y = dimensions.y / sprite_size.y

func _ready():
	up_extend_value = up_extend_value
	down_extend_value = down_extend_value
	left_extend_value = left_extend_value
	right_extend_value = right_extend_value

func _process(delta):
	var area: ClickArea = $ClickArea
	label.text = str(area.is_hovered)
	
	if area.is_hovered:
		if Input.is_action_just_pressed("left_click"):
			expand(Direction.RIGHT, 4)

func _physics_process(delta):
	if is_gravity_enabled and not is_on_floor():
			velocity += get_gravity() * delta
	
	const rot_speed = 0.1
	var alpha = fmod(fmod(angle, 90) + 90, 90)
	
	if is_on_floor() and alpha != 0:
		if alpha < 45:
			angle -= alpha * rot_speed
		else:
			angle += alpha * rot_speed

	move_and_slide()

func _on_scale_handle_mouse_entered():
	pass # Replace with function body.
