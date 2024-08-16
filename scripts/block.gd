@tool
extends CharacterBody2D
class_name Block

enum Direction {
	LEFT, RIGHT, UP, DOWN
}

@export var is_gravity_enabled = true
@export var dimensions: Vector2i = Vector2i(16, 16):
	set(value):
		dimensions = value
		_set_dimensions(value)

@export var rotatable: bool = false
@export_range(-360, 360) var angle: float = 0:
	set(value):
		angle = value
		$CollisionShape.rotation_degrees = value
		$Sprite.rotation_degrees = value

@onready var label := $Label

var is_hovered := false

@export_group("Up Extandable")
@export var up_extendable: bool = false
@export var up_extend_range: Vector2i = Vector2i(5, 50)

@export_group("Down Extandable")
@export var down_extendable: bool = false
@export var down_extend_range: Vector2i = Vector2i(5, 50)

@export_group("Left Extandable")
@export var left_extendable: bool = false
@export var left_extend_range: Vector2i = Vector2i(5, 50)

@export_group("Right Extandable")
@export var right_extendable: bool = false
@export var right_extend_range: Vector2i = Vector2i(5, 50)

func _set_dimensions(value):
	var collision_shape = $CollisionShape
	var click_area = $ClickArea
	var click_area_collision_shape = $ClickArea/ClickAreaCollisionShape
	var shape = collision_shape.shape
	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = value
	click_area_collision_shape.shape = shape
	
	# Update position
	var child_pos: Vector2 = Vector2(dimensions)/2
	collision_shape.position = child_pos
	click_area.position = child_pos
	_update_sprite_size(child_pos)

func _update_sprite_size(pos):
	var sprite: Sprite2D = $Sprite
	
	sprite.position = pos
	
	var sprite_size = sprite.texture.get_size()
	sprite.scale.x = dimensions.x / sprite_size.x
	sprite.scale.y = dimensions.y / sprite_size.y

func expand(direction: Direction, amount: int):
	if direction == Direction.RIGHT and right_extendable:
		dimensions.x += amount
	elif direction == Direction.LEFT and left_extendable:
		dimensions.x += amount
		position.x -= amount
	elif direction == Direction.DOWN and down_extendable:
		dimensions.y += amount
	elif direction == Direction.UP and up_extendable:
		dimensions.y += amount
		position.y -= amount

func _ready():
	dimensions = dimensions

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	var area: ClickArea = $ClickArea
	label.text = str(area.is_hovered)

func _physics_process(delta):
	if is_gravity_enabled and not is_on_floor():
			velocity += get_gravity() * delta

	move_and_slide()

func _on_click_area_clicked():
	expand(Direction.UP, 4)
