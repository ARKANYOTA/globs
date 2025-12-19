@tool
extends Area2D
class_name Block

enum Direction {
	LEFT, RIGHT, UP, DOWN, INVALID
}

const dir_map = [
	Vector2i(-1, 0), 
	Vector2i(1, 0), 
	Vector2i(0, -1), 
	Vector2i(0, 1)
]

@export var is_main_character := false:
	set(value):
		is_main_character = value 
		_update_sprite()

@export var static_block := false:
	set(value):
		static_block = value
		if value:
			is_gravity_enabled = false
		_update_sprite()

@export var is_gravity_enabled := true:
	set(value):
		is_gravity_enabled = value
		if value:
			static_block = false
		_update_sprite()

@export var default_gravity_axis := Direction.DOWN :
	set(value):
		default_gravity_axis = value
		gravity_axis = value
		_update_sprite()


@export var max_pushs := 1
@export var push_bounce := false

var gravity_axis = Direction.DOWN

@export_group("Visuals")
@export var click_to_update_sprite = false:
	set(value):
		_update_sprite()

@export var show_eyes: bool = true:
	set(value):
		show_eyes = value
		_update_sprite()
@export var happy_probability := 0.333


@export_group("Selection")
@export var click_area_extension := Vector2.ZERO
@export var drag_extend_only_area_size: int = 8


@export_group("Extendable Directions")
@export_subgroup("Up Extendable")
@export var up_extendable: bool = false
@export var up_extend_range: Vector2i = Vector2i(8, 24)
@export var up_extend_block_range: Vector2i = Vector2i(0, 1):
	set(value):
		up_extend_block_range = value
		update_range_from_block_range()

@export var up_extend_value: float = 8:
	set(value):
		up_extend_value = clamp(value, up_extend_range.x, up_extend_range.y)
		update_dimensions()

@export_subgroup("Down Extendable")
@export var down_extendable: bool = false
@export var down_extend_range: Vector2i = Vector2i(8, 24)
@export var down_extend_block_range: Vector2i = Vector2i(0, 1): 
	set(value):
		down_extend_block_range = value
		update_range_from_block_range()
@export var down_extend_value: float = 8:
	set(value):
		down_extend_value = clamp(value, down_extend_range.x, down_extend_range.y)
		update_dimensions()

@export_subgroup("Left Extendable")
@export var left_extendable: bool = false
@export var left_extend_range: Vector2i = Vector2i(8, 24)
@export var left_extend_block_range: Vector2i = Vector2i(0, 1):
	set(value):
		left_extend_block_range = value
		update_range_from_block_range()
@export var left_extend_value: float = 8:
	set(value):
		left_extend_value = clamp(value, left_extend_range.x, left_extend_range.y)
		update_dimensions()

@export_subgroup("Right Extendable")
@export var right_extendable: bool = false
@export var right_extend_range: Vector2i = Vector2i(8, 24)
@export var right_extend_block_range: Vector2i = Vector2i(0, 1):
	set(value):
		right_extend_block_range = value
		update_range_from_block_range()
@export var right_extend_value: float = 8:
	set(value):
		right_extend_value = clamp(value, right_extend_range.x, right_extend_range.y)
		update_dimensions()
		
@export_group("Time Left")
@export var time_left: int = 0
@export var is_time_global: bool = true

################################################

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var sleep_particles: CPUParticles2D = $Sleep/SleepParticles
@onready var click_audio: AudioStreamPlayer2D = $Audio/ClickAudio
@onready var slide_audio: AudioStreamPlayer2D = $Audio/SlideAudio
@onready var wake_up_audio: AudioStreamPlayer2D = $Audio/WakeUpAudio

const move_speed := 0.2
const ease_type := Tween.EASE_OUT
const transition_type := Tween.TRANS_QUART

var is_happy := false
var is_hovered := false
var is_selected := false
var handles: Dictionary = Dictionary()
var direction_indicator: PackedScene = preload("res://scenes/handler/direction_indicator.tscn")

var animation = "o_face"
var is_asleep := true
var is_moving := false
var moving_direction := Direction.INVALID
var is_falling := false

var drag_start_position: Vector2
var drag_mouse_dead_zone = 8
var drag_selected_side_x: Direction
var drag_selected_side_y: Direction
var drag_selected_edge: Direction
var drag_start_left_extend_value: float
var drag_start_right_extend_value: float
var drag_start_up_extend_value: float
var drag_start_down_extend_value: float

var remaining_pushs := -1
var tween_list = []

###### SLEEP animation #######
@onready var sleep_timer : Timer = $Sleep/SleepTimer
var time_before_sleeping_min := 5 # useless
var time_before_sleeping_max := 5 # useless
var time_before_sleeping := 5

################################################

func get_extend_range(direction: Direction) -> Vector2i:
	assert(direction != Direction.INVALID, "Invalid direction")
	if direction == Direction.LEFT:
		return left_extend_range
	elif direction == Direction.RIGHT:
		return right_extend_range
	elif direction == Direction.UP:
		return up_extend_range
	else:
		return down_extend_range

func get_extend_value(direction: Direction) -> float:
	assert(direction != Direction.INVALID, "Invalid direction")
	if direction == Direction.LEFT:
		return left_extend_value
	elif direction == Direction.RIGHT:
		return right_extend_value
	elif direction == Direction.UP:
		return up_extend_value
	else:
		return down_extend_value

func set_extend_value(direction: Direction, value) -> void:
	assert(direction != Direction.INVALID, "Invalid direction")
	if direction == Direction.LEFT:
		left_extend_value = value
	elif direction == Direction.RIGHT:
		right_extend_value = value
	elif direction == Direction.UP:
		up_extend_value = value
	else:
		down_extend_value = value

func is_extendable(direction: Direction) -> bool:
	if direction == Direction.RIGHT:
		return right_extendable
	if direction == Direction.LEFT:
		return left_extendable
	if direction == Direction.UP:
		return up_extendable
	if direction == Direction.DOWN:
		return down_extendable
	return false

# SCOTCH!
func can_extend_or_retract(side: Direction, movement_dir: Direction) -> bool:
	var extendable = is_extendable(side)
	if not extendable:
		return false
	
	var extent_value = get_extend_value(side)
	var extent_range = get_extend_range(side)
	var side_sign = (1 if side == Direction.RIGHT or side == Direction.DOWN else -1)
	var movement_sign = (1 if side == Direction.RIGHT or side == Direction.DOWN else -1)
	var val = extent_value + side_sign * movement_sign * 16
	var output = extent_range.x < val and val < extent_range.y

	return output

func hide_block():
	hide()
	GameManager.on_globs_hidden.emit(self)

func can_retract(dir: Direction, val) -> bool:
	if dir == Direction.LEFT:
		return left_extend_range.x < val
	elif dir == Direction.RIGHT:
		return right_extend_range.x < val
	elif dir == Direction.UP:
		return up_extend_range.x < val
	elif dir == Direction.DOWN:
		return down_extend_range.x < val
	return false

# SCOTCH!
func can_extend(dir: Direction) -> bool:
	if is_moving or is_falling:
		return false
	
	if dir == Direction.LEFT:
		return left_extendable and  left_extend_value < left_extend_range.y
	elif dir == Direction.RIGHT:
		return right_extendable and right_extend_value < right_extend_range.y
	elif dir == Direction.UP:
		return up_extendable and    up_extend_value < up_extend_range.y
	elif dir == Direction.DOWN:
		return down_extendable and  down_extend_value < down_extend_range.y
	return false

func expand(direction: Direction, amount: int) -> void:
	assert(direction != Direction.INVALID, "Invalid direction")
	if direction == Direction.RIGHT:
		right_extend_value += amount
	if direction == Direction.LEFT:
		left_extend_value += amount
	if direction == Direction.UP:
		up_extend_value += amount
	if direction == Direction.DOWN:
		down_extend_value += amount

func get_opposite_direction(direction: Direction) -> Direction:
	assert(direction != Direction.INVALID, "Invalid direction")
	if direction == Direction.LEFT:
		return Direction.RIGHT
	elif direction == Direction.RIGHT:
		return Direction.LEFT
	elif direction == Direction.UP:
		return Direction.DOWN
	else:
		return Direction.UP

## Returns a list of angles representing the directions the Block can extend in. 
## Ex: if the Block can move in `Direction.UP` and `Direction.RIGHT`, this will return `[Direction.UP, Direction.RIGHT]`
func get_extendable_directions() -> Array[Direction]: # TODO init this in _ready
	var dirs: Array[Direction] = []
	if up_extendable:
		dirs.append(Direction.UP)
	if down_extendable:
		dirs.append(Direction.DOWN)
	if left_extendable:
		dirs.append(Direction.LEFT)
	if right_extendable:
		dirs.append(Direction.RIGHT)
	return dirs

## Returns a list of angles representing the directions the Block can extend in. 
## Ex: if the Block can move in `Direction.UP` and `Direction.RIGHT`, this will return `[-PI/2, 0]`
func get_extendable_direction_angles() -> Array[float]: 
	return get_extendable_directions().map(direction_to_rotation)

#####################################################################################################


func update_range_from_block_range():
	up_extend_range =    Vector2i(up_extend_block_range    * 16 + Vector2i(8, 8))
	down_extend_range =  Vector2i(down_extend_block_range  * 16 + Vector2i(8, 8))
	left_extend_range =  Vector2i(left_extend_block_range  * 16 + Vector2i(8, 8))
	right_extend_range = Vector2i(right_extend_block_range * 16 + Vector2i(8, 8))

func update_dimensions():
	var dim: Vector2 = Vector2(left_extend_value + right_extend_value, 
							   up_extend_value + down_extend_value)
	var grid_dim: Vector2i = (get_grid_rect().size - Vector2i(1, 1)) * 16 + Vector2i(8, 8)
	var click_area: ClickArea = $ClickArea
	var block_collision_shape: CollisionShape2D = $CollisionShape
	var shape = block_collision_shape.shape
	var light_occ : LightOccluder2D = $BlockOccluder

	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = grid_dim
	if light_occ != null:
		light_occ.occluder.polygon = [Vector2(-dim.x/2, -dim.y/2), Vector2(dim.x/2, -dim.y/2), Vector2(dim.x/2, dim.y/2), Vector2(-dim.x/2, dim.y/2)]
	
	# Update position
	var child_pos: Vector2 = Vector2(-left_extend_value + right_extend_value,
									 -up_extend_value   + down_extend_value) / 2
	if light_occ != null:
		light_occ.position = child_pos
	block_collision_shape.position = child_pos
	update_sprite_size(child_pos, dim)

	click_area.set_click_area_size_and_position(dim + click_area_extension, child_pos)

func update_sprite_size(_pos, dimensions):
	var nine_patch: NinePatchRect = $NinePatch
	nine_patch.position = round(get_center() - dimensions/2)
	nine_patch.size = round(dimensions)

func select():
	if is_selected:
		return
	
	is_selected = true
	extend_direction_indicator()
	BlockManagerAutoload.on_select_block(self)
	
	click_audio.pitch_scale = 1.0
	click_audio.play()

func unselect():
	if not is_selected:
		return
	
	is_selected = false
	retract_direction_indicator()
	BlockManagerAutoload.on_unselect_block(self)
	
	click_audio.pitch_scale = 0.8
	click_audio.play()

func get_dimensions():
	return Vector2(left_extend_value + right_extend_value, up_extend_value + down_extend_value)

func get_rect() -> Rect2i:
	return Rect2i(int(position.x - left_extend_value), int(position.y - up_extend_value), 
				int(left_extend_value + right_extend_value), int(up_extend_value + down_extend_value))

func get_grid_rect() -> Rect2i:
	var rect = get_rect()
	return Rect2i((rect.position.x + 8) / 16, (rect.position.y + 8) / 16,
				   (rect.size.x + 8) / 16, (rect.size.y + 8) / 16)

func get_center():
	return $CollisionShape.position

func get_all_tree_nodes():
	return get_tree().get_nodes_in_group("level_element")

func enter_gravity_zone(direction: Direction, default: bool):
	gravity_axis = direction
	if default:
		default_gravity_axis = direction

func exit_gravity_zone(prev_direction: Direction):
	if gravity_axis != prev_direction:
		return
	gravity_axis = default_gravity_axis

func print_grid(grid):
	for line in grid:
		var l = ""
		for row in line:
			var c = "D"
			if row == -2:
				c = " "
			if row == -1:
				c = "S"
			l += c
		print(l)

func get_map_data() -> Array:
	var grid := []
	var blocks := []
	
	for node in get_all_tree_nodes():
		if node is TileMapLayer:
			if not node.collision_enabled:
				continue
			var cells = node.get_used_cells()
			var xmax = 0
			var ymax = 0
			for cell in cells:
				if cell.x > xmax:
					xmax = cell.x
				if cell.y > ymax:
					ymax = cell.y
			for y in range(ymax + 1):
				grid.append([])
				for x in range(xmax + 1):
					grid[y].append(-2) # empty
			
			for cell in cells:
				if cell.x < 0 or cell.y < 0:
					continue
				grid[cell.y][cell.x] = -1 # static
		if node is Block and node.is_visible():
			var id = -1
			if not node.static_block and not node.is_falling:
				id = blocks.size()
				blocks.append(node)
			var rect = node.get_grid_rect()
			var ymin = rect.position.y
			var ymax = rect.position.y + rect.size.y
			var xmin = rect.position.x
			var xmax = rect.position.x + rect.size.x
			
			for y in range(ymin, ymax):
				for x in range(xmin, xmax):
					if y < 0 or y >= len(grid) or x < 0 or y >= len(grid[y]):
						continue
					grid[y][x] = id
	return [grid, blocks]

func left(direction):
	return Vector2i(direction.y, -direction.x)

func right(direction):
	return Vector2i(-direction.y, direction.x)

func get_moved_blocks(grid: Array, x: int, y: int, direction: Vector2i, moved_blocks: Array) -> Array:
	if y < 0 or y >= len(grid) or x < 0 or x >= len(grid[y]):
		return []
	
	if grid[y][x] == -2:
		return moved_blocks
	if grid[y][x] == -1:
		return []

	var val = grid[y][x]
	grid[y][x] = -2

	if not val in moved_blocks:
		moved_blocks.append(val)
	
	var left_dir = left(direction)
	if grid[y + left_dir.y][x + left_dir.x] == val:
		var mov = get_moved_blocks(grid, x + left_dir.x, y + left_dir.y, direction, moved_blocks)
		if mov.is_empty():
			return []
		moved_blocks = mov
	
	var right_dir = right(direction)
	if grid[y + right_dir.y][x + right_dir.x] == val:
		var mov = get_moved_blocks(grid, x + right_dir.x, y + right_dir.y, direction, moved_blocks)
		if mov.is_empty():
			return []
		moved_blocks = mov
	
	return get_moved_blocks(grid, x + direction.x, y + direction.y, direction, moved_blocks)

func get_pos(direction: Direction) -> Vector2i:
	var rect = get_grid_rect()
	if direction == Direction.LEFT or direction == Direction.UP:
		return Vector2i(rect.position.x, rect.position.y)
	if direction == Direction.RIGHT:
		return Vector2i(rect.position.x + (rect.size.x - 1), rect.position.y)
	return Vector2i(rect.position.x, rect.position.y + (rect.size.y - 1))

func check_move_block(grid: Array, dir: Direction) -> Array:
	var direction = dir_map[dir]
	var rect = get_grid_rect()
	var pos = get_pos(dir)
	var moved_blocks := [-1]

	if dir == Direction.DOWN or dir == Direction.UP:
		for x in range(rect.size.x):
			moved_blocks = get_moved_blocks(grid, pos.x + x + direction.x, pos.y + direction.y, direction, moved_blocks)
			if moved_blocks.is_empty():
				return []
	if dir == Direction.LEFT or dir == Direction.RIGHT:
		for y in range(rect.size.y):
			moved_blocks = get_moved_blocks(grid, pos.x + direction.x, pos.y + y + direction.y, direction, moved_blocks)
			if moved_blocks.is_empty():
				return []
	return moved_blocks

func get_elements_by_id(blocks: Array, ids: Array) -> Array:
	var ans := []
	for id in ids:
		if id == -1:
			ans.append(self)
		else:
			ans.append(blocks[id])
	return ans


func check_movements(dir: Direction) -> Array: # value 0: moved_blocks and value 1: is opposite direction
	var map_data = get_map_data() # Value 0: Block and1value  :Grid
	var moved_blocks = get_elements_by_id(map_data[1], check_move_block(map_data[0], dir))

	if not moved_blocks.is_empty():
		return [moved_blocks, false]
	
	if not static_block:
		moved_blocks = get_elements_by_id(map_data[1], check_move_block(map_data[0], get_opposite_direction(dir)))
	
	return [moved_blocks, true]

func get_variation(dir: Direction, pos_diff: Vector2) -> float:
	# var pos_diff = get_global_mouse_position() - global_position
	if dir == Direction.LEFT:
		return pos_diff.x + left_extend_value - drag_start_left_extend_value
	if dir == Direction.RIGHT:
		return pos_diff.x - right_extend_value + drag_start_right_extend_value
	if dir == Direction.UP:
		return pos_diff.y + up_extend_value - drag_start_up_extend_value
	if dir == Direction.DOWN:
		return pos_diff.y - down_extend_value + drag_start_down_extend_value
	return -1


################################################


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

func _update_sprite():
	if get_node_or_null("CenterIndicator"):
		$CenterIndicator.visible = show_eyes

	# Update animation
	_update_animation()
	
	# Change 9-patch sprite
	var ninepatch: NinePatchRect = get_node_or_null("NinePatch")
	if not ninepatch:
		return
	
	if is_main_character: # Normal
		ninepatch.region_rect.position = Vector2(0, 96)
	elif static_block: # Normal
		ninepatch.region_rect.position = Vector2(16, 80)
	elif is_gravity_enabled: # Gravity
		if default_gravity_axis == Direction.UP:
			ninepatch.region_rect.position = Vector2(32, 80+16)
		elif default_gravity_axis == Direction.LEFT:
			ninepatch.region_rect.position = Vector2(32+16, 80)
		elif default_gravity_axis == Direction.RIGHT:
			ninepatch.region_rect.position = Vector2(32+16, 80+16)
		else:
			ninepatch.region_rect.position = Vector2(32, 80)
	else:
		ninepatch.region_rect.position = Vector2(0, 80)

	#else: # bleu
		#ninepatch.region_rect.position.x = 0
		#ninepatch.region_rect.position.y = 32
	var centerindicator: AnimatedSprite2D = $CenterIndicator
	if not centerindicator:
		return
	centerindicator.rotation = direction_to_rotation(gravity_axis) - PI/2


func _update_animation():
	var dim = get_dimensions()
	var size = dim.x * dim.y
	var old_animation = animation
	
	if sleep_particles:
		sleep_particles.emitting = is_asleep
	if is_asleep:
		animation = "sleeping"
		return

	if size <= 4*16*16:
		if is_happy:
			animation = "happy"
		else:
			animation = "poker"
	elif size <= 6*16*16:
		animation = "fat"
	else:
		animation = "scared"

func _create_direction_indicator(direction: Direction, handle_name: String):
	var dimensions = get_dimensions()
	var handle_position = get_center() + Util.direction_to_vector(direction) * (dimensions/2)
	var new_direction_indicator = direction_indicator.instantiate()
	new_direction_indicator.block = self
	new_direction_indicator.direction = direction

	add_child(new_direction_indicator)
	new_direction_indicator.initialize()
	
	handles[direction] = new_direction_indicator

func _create_direction_indicators():
	if left_extendable:
		_create_direction_indicator(Direction.LEFT, "LeftHandle")
	if right_extendable:
		_create_direction_indicator(Direction.RIGHT, "RightHandle")
	if up_extendable:
		_create_direction_indicator(Direction.UP, "UpHandle")
	if down_extendable:
		_create_direction_indicator(Direction.DOWN, "DownHandle")
	
	_update_scale_handles()

func _update_scale_handles():
	pass

func retract_direction_indicator():
	for handle in handles.values():
		handle.retract_indicator()

func extend_direction_indicator():
	for handle in handles.values():
		handle.extend_indicator()

func hide_direction_indicator():
	for handle in handles.values():
		handle.hide_indicator()

func show_direction_indicator():
	for handle in handles.values():
		handle.show_indicator()

func start_grow():
	
	if not collision_shape:
		return
	var collision_shape_shape: RectangleShape2D = collision_shape.shape
	if not collision_shape_shape:
		return
	var aspect_ratio = collision_shape_shape.size.x / collision_shape_shape.size.y
	
	var mouse_pos = get_local_mouse_position()
	var mouse_offset: Vector2 = (mouse_pos) * Vector2(1/aspect_ratio, 1)
	var mouse_angle = mouse_offset.angle()

	drag_start_position = mouse_pos 
	drag_selected_edge = Direction.INVALID
	drag_selected_side_x = Direction.LEFT if mouse_pos.x < 0 else Direction.RIGHT
	drag_selected_side_y = Direction.UP   if mouse_pos.y < 0 else Direction.DOWN

	drag_start_left_extend_value = left_extend_value
	drag_start_right_extend_value = right_extend_value
	drag_start_up_extend_value = up_extend_value
	drag_start_down_extend_value = down_extend_value

	wake_up()
	select()

func stop_grow():
	sleep_timer.start()
	unselect()

################################################

func _ready():
	add_to_group("level_element")
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	
	if Engine.is_editor_hint():
		return
	
	if randf() < happy_probability:
		is_happy = true
	_update_sprite()
	
	up_extend_value = up_extend_value
	down_extend_value = down_extend_value
	left_extend_value = left_extend_value
	right_extend_value = right_extend_value
	_create_direction_indicators()
	
	update_dimensions()
	init_sleep_timer()
	BlockManagerAutoload.register_block(self)

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	$CenterIndicator.play(animation)

	# DEBUG
	# $Label.text = str(is_moving or is_falling)

func same_axis(dir1, dir2):
	if dir1 == Direction.LEFT or dir1 == Direction.RIGHT:
		return dir2 == Direction.LEFT or dir2 == Direction.RIGHT
	if dir1 == Direction.UP or dir1 == Direction.DOWN:
		return dir2 == Direction.UP or dir2 == Direction.DOWN
	return false

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if not is_visible():
		return
	
	if is_gravity_enabled and not is_falling and not (is_moving and same_axis(gravity_axis, moving_direction)):
		var map_data = get_map_data()
		var grid = map_data[0]
		var rect = get_grid_rect()
		var can_fall = true
		
		var spos = get_pos(gravity_axis)
		var dir = dir_map[gravity_axis]
		var line_size = rect.size.x if gravity_axis == Direction.DOWN or gravity_axis == Direction.UP else rect.size.y

		for i in range(line_size):
			var x = spos.x + i + dir.x if gravity_axis == Direction.DOWN or gravity_axis == Direction.UP else spos.x + dir.x
			var y = spos.y + i + dir.y if gravity_axis == Direction.LEFT or gravity_axis == Direction.RIGHT else spos.y + dir.y
			if grid[y][x] != -2:
				can_fall = false
				break
		
		if can_fall:
			var gravity_tween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
			tween_list.append(gravity_tween)
			is_falling = true
			if gravity_axis == Direction.DOWN:
				gravity_tween.tween_property(self, "position:y", position.y + 16, move_speed).set_ease(ease_type).set_trans(transition_type)
			if gravity_axis == Direction.UP:
				gravity_tween.tween_property(self, "position:y", position.y - 16, move_speed).set_ease(ease_type).set_trans(transition_type)
			if gravity_axis == Direction.LEFT:
				gravity_tween.tween_property(self, "position:x", position.x - 16, move_speed).set_ease(ease_type).set_trans(transition_type)
			if gravity_axis == Direction.RIGHT:
				gravity_tween.tween_property(self, "position:x", position.x + 16, move_speed).set_ease(ease_type).set_trans(transition_type)

			gravity_tween.tween_callback(set_is_falling_to_false)
			gravity_tween.tween_callback(func (): tween_list.erase(gravity_tween))
		
	#if not is_falling and not is_moving:
	#	var gpos = get_grid_rect().position
	#	var pos = Vector2(gpos.x * 16 + left_extend_value, gpos.y * 16 + up_extend_value)

	#	if position.x != pos.x or position.y != pos.y:
	#		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
	#		is_falling = true

	#		tween.tween_property(self, "position", pos, move_speed / 2).set_ease(Tween.EASE_IN_OUT)
	#		tween.tween_callback(set_is_falling_to_false)
	
	_update_scale_handles()
	_update_sprite()


############################################################################################################################################
##### CLICK AREA
############################################################################################################################################

func _on_click_area_start_drag():
	start_grow()

func _on_click_area_end_drag():
	stop_grow()

## Returns the edge that should be selected, based on the movement of the cursor.
func _get_selected_edge(movement_direction: Direction, mouse_pos: Vector2) -> Direction:
	var selected_edge: Direction = Direction.INVALID

	# Select the edge that is the closest in the respective chosen axis
	if (left_extendable or right_extendable) and (movement_direction == Direction.RIGHT or movement_direction == Direction.LEFT):
		selected_edge = drag_selected_side_x
		if abs(drag_start_position.x) <= drag_extend_only_area_size:
			selected_edge = movement_direction
	
	elif (up_extendable or down_extendable) and (movement_direction == Direction.UP or movement_direction == Direction.DOWN):
		selected_edge = drag_selected_side_y
		if abs(drag_start_position.y) <= drag_extend_only_area_size:
			selected_edge = movement_direction
	
	if not is_extendable(selected_edge) and selected_edge != Direction.INVALID:
		return get_opposite_direction(selected_edge)

	return selected_edge



func _on_click_area_dragging():
	if is_moving or not is_selected:
		return
	
	var mouse_pos = get_local_mouse_position()
	var mouse_diff = mouse_pos - drag_start_position
	var mouse_dist = drag_start_position.distance_to(mouse_pos)
	
	if mouse_dist < drag_mouse_dead_zone:
		return

	var movement_direction = Util.snap_vector_to_direction(mouse_diff)
	if movement_direction == Direction.INVALID:
		return
	
	var selected_edge: Direction = drag_selected_edge
	if drag_selected_edge == Direction.INVALID:
		selected_edge = _get_selected_edge(movement_direction, mouse_pos)
		if selected_edge == Direction.INVALID:
			return
	
	var variation = get_variation(selected_edge, mouse_diff)

	if abs(variation) < 8:
		return
	
	if variation > 0:
		variation = 16
	else:
		variation = -16

	extend_block(variation, selected_edge, false)
	if drag_selected_edge == Direction.INVALID:
		drag_selected_edge = selected_edge
		set_highlighted_edge(drag_selected_edge)

func set_highlighted_edge(edge: Direction = drag_selected_edge):
	for handle_edge in handles:
		handles[handle_edge].set_highlighted(false)

	if handles.has(edge):
		handles[edge].set_highlighted(true)
	
func set_is_moving_to_false():
	is_moving = false
	moving_direction = Direction.INVALID

func set_is_falling_to_false():
	is_falling = false

func is_same_axis(dir: Direction, odir: Direction):
	return dir == odir or dir == get_opposite_direction(odir)

func _on_cannot_extend(direction: Direction):
	if handles.has(direction):
		if handles[direction].is_highlighted:
			handles[direction].play_max_extent_animation()

func extend_block(variation: int, direction: Direction, push: bool):
	var extend = push or can_extend(direction)
	
	if get_tree() == null:
		return
	if not is_visible():
		return
	

	var val: float
	var tween_property = ""
	var movements: Array = []
	var reverse := false
	if direction == Direction.LEFT:
		if variation < 0:
			var check = check_movements(direction)
			movements = check[0]
			reverse = check[1]
			if not extend or movements.is_empty():
				_on_cannot_extend(direction)
				remaining_pushs = -1
				return

		val = left_extend_value - variation
		tween_property = "left_extend_value"
	
	elif direction == Direction.RIGHT:
		if variation > 0:
			var check = check_movements(direction)
			movements = check[0]
			reverse = check[1]
			if not extend or movements.is_empty():
				_on_cannot_extend(direction)
				remaining_pushs = -1
				return
		val = right_extend_value + variation
		tween_property = "right_extend_value"
	
	elif direction == Direction.UP:
		if variation < 0:
			var check = check_movements(direction)
			movements = check[0]
			reverse = check[1]
			if not extend or movements.is_empty():
				_on_cannot_extend(direction)
				remaining_pushs = -1
				return
		val = up_extend_value - variation
		tween_property = "up_extend_value"

	elif direction == Direction.DOWN:
		if variation > 0:
			var check = check_movements(direction)
			movements = check[0]
			reverse = check[1]
			if not extend or movements.is_empty():
				_on_cannot_extend(direction)
				remaining_pushs = -1
				return
		
		val = down_extend_value + variation
		tween_property = "down_extend_value"

	if reverse and push and not push_bounce:
		remaining_pushs = -1
		return
	
	if is_moving:
		return

	is_moving = true
	var mul = -1 if reverse else 1
	var off = mul * 16 if direction == Direction.RIGHT or direction == Direction.DOWN else mul * -16

	assert(get_parent() != null, "The level is null")

	if not push and val != -8:
		get_parent().go_to_next_actions()

	var tween_transition = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
	tween_list.append(tween_transition)

	for i in range(int(not reverse and not push), len(movements)):
		var move_tween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
		tween_list.append(move_tween)

		var block: Block = movements[i]
		if not block: # FIXME SCOTCH, remove if causes issues
			continue
		
		#position qui bouge
		block.moving_direction = direction
		if direction == Direction.RIGHT or direction == Direction.LEFT:
			move_tween.tween_property(block, "position:x", block.position.x + off, move_speed).set_ease(ease_type).set_trans(transition_type)

		if direction == Direction.DOWN or direction == Direction.UP:
			move_tween.tween_property(block, "position:y", block.position.y + off, move_speed).set_ease(ease_type).set_trans(transition_type)


		move_tween.tween_callback(func(): if block: block.is_moving = false)
		move_tween.tween_callback(func(): if block: block.moving_direction = Direction.INVALID)
		block.is_moving = true

		if block.is_gravity_enabled and is_same_axis(block.gravity_axis, direction):
			block.remaining_pushs = -1
		else:
			if block.remaining_pushs < 0:
				block.remaining_pushs = block.max_pushs - 1
			
			if block.remaining_pushs == 0:
				block.remaining_pushs = -1
			else:
				block.remaining_pushs -= 1
				if block == null:
					return
				move_tween.tween_callback(func(): block.extend_block(off, direction if not reverse else get_opposite_direction(direction), true))

		move_tween.tween_callback(func (): tween_list.erase(move_tween))
	
		
	if tween_property != "" and not push and val != -8:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CIRC)
		tween_list.append(tween)
		tween.tween_property(self, tween_property, val, move_speed).set_ease(ease_type).set_trans(transition_type)
		tween.tween_callback(func (): tween_list.erase(tween))

		slide_audio.play()



	if not push and val != -8:
		tween_transition.tween_callback(update_positions).set_delay(move_speed)
		
	if remaining_pushs == -1:
		tween_transition.tween_callback(set_is_moving_to_false)
	tween_transition.tween_callback(func (): tween_list.erase(tween_transition))

	_update_scale_handles()

func update_positions():
	assert(get_parent() != null, "Block.update_positions: The level is null")
	get_parent().upgrade_time_to_everyone(self)


func _on_scale_handle_dragged(handle: ScaleHandle, direction: Direction):
	if is_moving or not is_selected:
		return
	
	# var variation = get_variation(direction)
	# if abs(variation) < 8:
	# 	return
	
	# if variation > 0:
	# 	variation = 16
	# else:
	# 	variation = -16
	
	# extend_block(variation, direction, false)



## SLEEP FUNCTION

func init_sleep_timer():
	sleep_timer.timeout.connect(_on_sleep_timer_timeout)
	sleep_timer.set_wait_time(time_before_sleeping)
	sleep_timer.one_shot = true

func _on_sleep_timer_timeout():
	if is_asleep:
		return
	is_asleep = true
	_update_animation()

func get_random_sleeping_time():
	return time_before_sleeping_min + randi() % (time_before_sleeping_max - time_before_sleeping_min)

func wake_up():
	sleep_timer.stop()
	if not is_asleep:
		return
	is_asleep = false
	wake_up_audio.play()
	if get_parent() == null:
		return
	if get_parent() is not Level:
		return
	get_parent().add_awake_block(self)
	
