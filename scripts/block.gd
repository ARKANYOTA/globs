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

@export_group("Up Extandable")
@export var up_extendable: bool = false
@export var up_extend_range: Vector2i = Vector2i(8, 100)
@export var up_extend_value: float = 8:
	set(value):
		up_extend_value = clamp(value, up_extend_range.x, up_extend_range.y)
		update_dimensions()

@export_group("Down Extandable")
@export var down_extendable: bool = false
@export var down_extend_range: Vector2i = Vector2i(8, 100)
@export var down_extend_value: float = 8:
	set(value):
		down_extend_value = clamp(value, down_extend_range.x, down_extend_range.y)
		update_dimensions()

@export_group("Left Extandable")
@export var left_extendable: bool = false
@export var left_extend_range: Vector2i = Vector2i(8, 100)
@export var left_extend_value: float = 8:
	set(value):
		left_extend_value = clamp(value, left_extend_range.x, left_extend_range.y)
		update_dimensions()

@export_group("Right Extandable")
@export var right_extendable: bool = false
@export var right_extend_range: Vector2i = Vector2i(8, 100)
@export var right_extend_value: float = 8:
	set(value):
		right_extend_value = clamp(value, right_extend_range.x, right_extend_range.y)
		update_dimensions()

################################################

@onready var main := get_node("/root/Main")
@onready var block_manager: BlockManager = get_node("/root/Main/BlockManager")
@onready var label := $Label

var is_hovered := false
var is_selected := false
var handles: Array[ScaleHandle] = []
var scale_handle: PackedScene = load("res://scenes/scale_handle.tscn")

################################################

func expand(direction: Direction, amount: int):
	if direction == Direction.RIGHT:
		right_extend_value += amount
	if direction == Direction.LEFT:
		left_extend_value += amount
	if direction == Direction.UP:
		up_extend_value += amount
	if direction == Direction.DOWN:
		down_extend_value += amount

func update_dimensions():
	var dim: Vector2 = Vector2(left_extend_value + right_extend_value, 
							   up_extend_value + down_extend_value)
	var collision_shape = $CollisionShape
	var click_area = $ClickArea
	var click_area_collision_shape = $ClickArea/ClickAreaCollisionShape
	var unclick_area_collision_shape = $UnClickArea/ClickAreaCollisionShape
	var shape = collision_shape.shape
	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = dim
	click_area_collision_shape.shape.size = dim
	unclick_area_collision_shape.shape.size = dim + Vector2(8, 8)
	
	# Update position
	var child_pos: Vector2 = Vector2(-left_extend_value + right_extend_value,
									 -up_extend_value   + down_extend_value) / 2
	collision_shape.position = child_pos
	unclick_area_collision_shape.position = child_pos
	click_area.position = child_pos
	update_sprite_size(child_pos, dim)

func update_sprite_size(pos, dimensions):
	var nine_patch: NinePatchRect = $NinePatch
	nine_patch.position = round(get_center() - dimensions/2)
	nine_patch.size = round(dimensions)

func select():
	if is_selected:
		return
	
	is_selected = true
	_show_scale_handles()
	block_manager.on_select_block(self)

func unselect():
	if not is_selected:
		return
	
	is_selected = false
	_hide_scale_handles()
	block_manager.on_unselect_block(self)

func get_dimensions():
	return Vector2(left_extend_value + right_extend_value, up_extend_value + down_extend_value)

func get_center():
	return $CollisionShape.position

################################################

func _create_scale_handle(direction: Direction, name: String):
	var new_scale_handle: ScaleHandle = scale_handle.instantiate()
	new_scale_handle.name = name
	new_scale_handle.direction = direction
	new_scale_handle.z_index = 10
	
	new_scale_handle.start_drag.connect(func():
		_on_scale_handle_start_drag(new_scale_handle, direction)
	)
	new_scale_handle.end_drag.connect(func():
		_on_scale_handle_end_drag(new_scale_handle, direction)
	)
	new_scale_handle.dragging.connect(func():
		_on_scale_handle_dragged(new_scale_handle, direction)
	)
	add_child(new_scale_handle)
	
	handles.append(new_scale_handle)

func _create_scale_handles():
	if left_extendable:
		_create_scale_handle(Direction.LEFT, "LeftHandle")
	if right_extendable:
		_create_scale_handle(Direction.RIGHT, "RightHandle")
	if up_extendable:
		_create_scale_handle(Direction.UP, "UpHandle")
	if down_extendable:
		_create_scale_handle(Direction.DOWN, "DownHandle")
	
	_update_scale_handles()

func _update_scale_handles():
	var center = get_center()
	var dimensions = get_dimensions()
	for handle in handles:
		var direction = handle.direction
		if direction == Direction.LEFT:
			handle.position = center - Vector2(dimensions.x / 2, 0)
		elif direction == Direction.RIGHT:
			handle.position = center + Vector2(dimensions.x / 2, 0)
		elif direction == Direction.UP:
			handle.position = center - Vector2(0, dimensions.y / 2)
		elif direction == Direction.DOWN:
			handle.position = center + Vector2(0, dimensions.y / 2)
		
		handle.position = round(handle.position)

func _hide_scale_handles():
	for handle in handles:
		handle.hide_handle()

func _show_scale_handles():
	for handle in handles:
		handle.show_handle()

################################################

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	$ClickArea/ClickAreaCollisionShape.shape = $ClickArea/ClickAreaCollisionShape.shape.duplicate()
	
	if Engine.is_editor_hint():
		return
	
	up_extend_value = up_extend_value
	down_extend_value = down_extend_value
	left_extend_value = left_extend_value
	right_extend_value = right_extend_value
	_create_scale_handles()
	_hide_scale_handles()
	
	update_dimensions()

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	_update_scale_handles()

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if is_gravity_enabled:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		const rot_speed = 0.1
		var alpha = fmod(fmod(angle, 90) + 90, 90)
		
		if is_on_floor() and alpha != 0:
			if alpha < 45:
				angle -= alpha * rot_speed
			else:
				angle += alpha * rot_speed
	
	move_and_slide()

func _on_click_area_clicked():
	if block_manager.can_select(self):
		block_manager.new_selection_candidate(self)

func _on_un_click_area_clicked_outside_area():
	unselect()

func _on_scale_handle_start_drag(handle: ScaleHandle, direction: Direction):
	block_manager.start_drag()

func _on_scale_handle_end_drag(handle: ScaleHandle, direction: Direction):
	block_manager.end_drag()

func _on_scale_handle_dragged(handle: ScaleHandle, direction: Direction):
	var pos_diff = get_global_mouse_position() - global_position
	if direction == Direction.LEFT:
		left_extend_value = abs(min(0, pos_diff.x))
	elif direction == Direction.RIGHT:
		right_extend_value = max(0, pos_diff.x)
	elif direction == Direction.UP:
		up_extend_value = abs(min(0, pos_diff.y))
	elif direction == Direction.DOWN:
		down_extend_value = max(0, pos_diff.y)
	
	_update_scale_handles()
