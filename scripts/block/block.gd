@tool
extends Area2D
class_name Block

enum Direction {
	LEFT, RIGHT, UP, DOWN
}

const dir_map = [
	Vector2i(-1, 0), 
	Vector2i(1, 0), 
	Vector2i(0, -1), 
	Vector2i(0, 1)
]

@export var click_to_update_sprite = false:
	set(value):
		_update_sprite()

@export var is_gravity_enabled := true:
	set(value):
		is_gravity_enabled = value
		if value:
			static_block = false
		_update_sprite()

@export var static_block := false:
	set(value):
		static_block = value
		if value:
			is_gravity_enabled = false
		_update_sprite()

@export var is_main_character := false:
	set(value):
		is_main_character = value
		_update_sprite()

@export var happy_probability = 0.333

@export var rotatable: bool = false
@export_range(-360, 360) var angle: float = 0:
	set(value):
		angle = value
		#$CollisionShape.rotation_degrees = value
		#$Sprite.rotation_degrees = value

@export var default_gravity_axis := Direction.DOWN :
	set(value):
		default_gravity_axis = value
		gravity_axis = value


@export var max_pushs := 1
@export var push_bounce := false

var gravity_axis = Direction.DOWN

@export_group("Up Extandable")
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

@export_group("Down Extandable")
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

@export_group("Left Extandable")
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

@export_group("Right Extandable")
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

################################################

@onready var main := get_node("/root/Main")
@onready var sleep_particles: CPUParticles2D = $Sleep/SleepParticles
@onready var click_audio: AudioStreamPlayer2D = $Audio/ClickAudio
@onready var slide_audio: AudioStreamPlayer2D = $Audio/SlideAudio

const move_speed := 0.1

var is_happy := false
var is_hovered := false
var is_selected := false
var handles: Array = []
var direction_indicators: Array[Sprite2D] = []
var scale_handle: PackedScene = load("res://scenes/handler/scale_handle.tscn")
var direction_indicator: PackedScene = load("res://scenes/handler/direction_indicator.tscn")

var animation = "o_face"
var is_asleep := false
var is_moving := false
var is_falling := false

var remaining_pushs := -1

################################################

	

func get_extend_value(direction: Direction):
	if direction == Direction.LEFT:
		return left_extend_value
	elif direction == Direction.RIGHT:
		return right_extend_value
	elif direction == Direction.UP:
		return up_extend_value
	elif direction == Direction.DOWN:
		return down_extend_value

func set_extend_value(direction: Direction, value):
	if direction == Direction.LEFT:
		left_extend_value = value
	elif direction == Direction.RIGHT:
		right_extend_value = value
	elif direction == Direction.UP:
		up_extend_value = value
	elif direction == Direction.DOWN:
		down_extend_value = value

func expand(direction: Direction, amount: int):
	if direction == Direction.RIGHT:
		right_extend_value += amount
	if direction == Direction.LEFT:
		left_extend_value += amount
	if direction == Direction.UP:
		up_extend_value += amount
	if direction == Direction.DOWN:
		down_extend_value += amount

func update_range_from_block_range():
	up_extend_range =    Vector2i(up_extend_block_range    * 16 + Vector2i(8, 8))
	down_extend_range =  Vector2i(down_extend_block_range  * 16 + Vector2i(8, 8))
	left_extend_range =  Vector2i(left_extend_block_range  * 16 + Vector2i(8, 8))
	right_extend_range = Vector2i(right_extend_block_range * 16 + Vector2i(8, 8))

func update_dimensions():
	var dim: Vector2 = Vector2(left_extend_value + right_extend_value, 
							   up_extend_value + down_extend_value)
	var collision_shape = $CollisionShape
	var click_area = $ClickArea
	var click_area_collision_shape = $ClickArea/ClickAreaCollisionShape
	var unclick_area_collision_shape = $UnClickArea/ClickAreaCollisionShape
	var shape = collision_shape.shape
	var light_occ : LightOccluder2D = $BlockOccluder

	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = dim
	click_area_collision_shape.shape.size = dim
	if light_occ != null:
		light_occ.occluder.polygon = [Vector2(-dim.x/2, -dim.y/2), Vector2(dim.x/2, -dim.y/2), Vector2(dim.x/2, dim.y/2), Vector2(-dim.x/2, dim.y/2)]
	unclick_area_collision_shape.shape.size = dim + Vector2(8, 8)
	
	# Update position
	var child_pos: Vector2 = Vector2(-left_extend_value + right_extend_value,
									 -up_extend_value   + down_extend_value) / 2
	if light_occ != null:
		light_occ.position = child_pos
	collision_shape.position = child_pos
	unclick_area_collision_shape.position = child_pos
	click_area.position = child_pos
	update_sprite_size(child_pos, dim)

func update_sprite_size(_pos, dimensions):
	var nine_patch: NinePatchRect = $NinePatch
	nine_patch.position = round(get_center() - dimensions/2)
	nine_patch.size = round(dimensions)

func select():
	if is_selected:
		return
	
	is_selected = true
	_show_scale_handles()
	extend_direction_indicator()
	BlockManagerAutoload.on_select_block(self)
	
	click_audio.pitch_scale = 1.0
	click_audio.play()

func unselect():
	if not is_selected:
		return
	
	is_selected = false
	_hide_scale_handles()
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

func get_all_tree_nodes(node = get_tree().get_root(), list = []):
	list.append(node)
	for childNode in node.get_children():
		list = get_all_tree_nodes(childNode, list)
	return list

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
		if node is Block:
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

func get_opposite_direction(direction: Direction) -> Direction:
	if direction == Direction.LEFT:
		return Direction.RIGHT
	if direction == Direction.RIGHT:
		return Direction.LEFT
	if direction == Direction.UP:
		return Direction.DOWN
	return Direction.UP

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

func get_variation(dir: Direction) -> float:
	var pos_diff = get_global_mouse_position() - global_position
	if dir == Direction.LEFT:
		return pos_diff.x + left_extend_value
	if dir == Direction.RIGHT:
		return pos_diff.x - right_extend_value
	if dir == Direction.UP:
		return pos_diff.y + up_extend_value
	if dir == Direction.DOWN:
		return pos_diff.y - down_extend_value
	return -1


func can_extend(dir: Direction):
	if dir == Direction.LEFT:
		return left_extend_value < left_extend_range.y
	if dir == Direction.RIGHT:
		return right_extend_value < right_extend_range.y
	if dir == Direction.UP:
		return up_extend_value < up_extend_range.y
	if dir == Direction.DOWN:
		return down_extend_value < down_extend_range.y

################################################

func _update_sprite():
	# Update animation
	_update_animation()
	
	# Change 9-patch sprite
	var ninepatch: NinePatchRect = $NinePatch
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


	#else: # bleu
		#ninepatch.region_rect.position.x = 0
		#ninepatch.region_rect.position.y = 32
	var centerindicator: AnimatedSprite2D = $CenterIndicator
	if not centerindicator:
		return
	centerindicator.rotation = Util.direction_to_rotation(gravity_axis) - PI/2


func _update_animation():
	var dim = get_dimensions()
	var size = dim.x * dim.y
	var old_animation = animation
	
	if not is_selected:
		animation = "sleeping"
	elif size <= 4*16*16:
		if is_happy:
			animation = "happy"
		else:
			animation = "poker"
	elif size <= 6*16*16:
		animation = "fat"
	else:
		animation = "scared"
	
	if sleep_particles:
		sleep_particles.emitting = (animation == "sleeping")

func _create_scale_handle(direction: Direction, handle_name: String):
	var new_scale_handle: ScaleHandle = scale_handle.instantiate()
	new_scale_handle.block = self
	new_scale_handle.name = handle_name
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
	new_scale_handle.initialize()
	
	var dimensions = get_dimensions()
	var handle_position = get_center() + Util.direction_to_vector(direction) * (dimensions/2)
	var new_direction_indicator = direction_indicator.instantiate()
	new_direction_indicator.base_position = handle_position
	new_direction_indicator.block = self
	new_direction_indicator.direction = direction
	add_child(new_direction_indicator)
	new_direction_indicator.initialize()
	
	handles.append({
		handle = new_scale_handle,
		direction_indicator = new_direction_indicator,
	})

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
	for handle_info in handles:
		var handle = handle_info["handle"]
		var direction = handle.direction
		var handle_position = center + Util.direction_to_vector(direction) * (dimensions/2)
		handle.position = round(handle_position) 
		
		var indicator = handle_info["direction_indicator"]
		indicator.is_held = handle.is_held
		indicator.base_position = round(handle_position)

func _hide_scale_handles():
	for handle in handles:
		handle["handle"].hide_handle()

func _show_scale_handles():
	for handle in handles:
		handle["handle"].show_handle()

func retract_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].retract_indicator()

func extend_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].extend_indicator()

func hide_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].hide_indicator()

func show_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].show_indicator()


################################################

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	$ClickArea/ClickAreaCollisionShape.shape = $ClickArea/ClickAreaCollisionShape.shape.duplicate()
	
	if Engine.is_editor_hint():
		return
	
	if randf() < happy_probability:
		is_happy = true
	_update_sprite()
	
	up_extend_value = up_extend_value
	down_extend_value = down_extend_value
	left_extend_value = left_extend_value
	right_extend_value = right_extend_value
	_create_scale_handles()
	_hide_scale_handles()
	
	update_dimensions()
	BlockManagerAutoload.register_block(self)

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	$CenterIndicator.play(animation)

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if is_gravity_enabled and not is_falling:
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
			var gravity_tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
			is_falling = true
			if gravity_axis == Direction.DOWN:
				gravity_tween.tween_property(self, "position:y", position.y + 16, move_speed).set_ease(Tween.EASE_OUT)
			if gravity_axis == Direction.UP:
				gravity_tween.tween_property(self, "position:y", position.y - 16, move_speed).set_ease(Tween.EASE_OUT)
			if gravity_axis == Direction.LEFT:
				gravity_tween.tween_property(self, "position:x", position.x - 16, move_speed).set_ease(Tween.EASE_OUT)
			if gravity_axis == Direction.RIGHT:
				gravity_tween.tween_property(self, "position:x", position.x + 16, move_speed).set_ease(Tween.EASE_OUT)

			gravity_tween.tween_callback(set_is_falling_to_false)
	
	_update_scale_handles()
	_update_sprite()

func _on_click_area_clicked():
	if BlockManagerAutoload.can_select(self):
		BlockManagerAutoload.new_selection_candidate(self)

func _on_un_click_area_clicked_outside_area():
	unselect()

func _on_scale_handle_start_drag(handle: ScaleHandle, direction: Direction):
	BlockManagerAutoload.start_drag()

func _on_scale_handle_end_drag(handle: ScaleHandle, direction: Direction):
	BlockManagerAutoload.end_drag()

func set_is_moving_to_false():
	is_moving = false 

func set_is_falling_to_false():
	is_falling = false

func is_same_axis(dir: Direction, odir: Direction):
	return dir == odir or dir == get_opposite_direction(odir)

func extend_block(variation: int, direction: Direction, push: bool):
	var extend = push or can_extend(direction)

	if get_tree() == null:
		return
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	var tween_transition = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	
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
				remaining_pushs = -1
				return
		
		val = down_extend_value + variation
		tween_property = "down_extend_value"

	if reverse and push and not push_bounce:
		remaining_pushs = -1
		return
	
	is_moving = true
	var mul = -1 if reverse else 1
	var off = mul * 16 if direction == Direction.RIGHT or direction == Direction.DOWN else mul * -16

	for i in range(int(not reverse and not push), len(movements)):
		var move_tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		var block: Block = movements[i]

		if direction == Direction.RIGHT or direction == Direction.LEFT:
			move_tween.tween_property(block, "position:x", block.position.x + off, move_speed).set_ease(Tween.EASE_OUT)
		if direction == Direction.DOWN or direction == Direction.UP:
			move_tween.tween_property(block, "position:y", block.position.y + off, move_speed).set_ease(Tween.EASE_OUT)

		if block.is_gravity_enabled and is_same_axis(block.gravity_axis, direction):
			block.remaining_pushs = -1
		else:
			if block.remaining_pushs < 0:
				block.remaining_pushs = block.max_pushs - 1
			
			if block.remaining_pushs == 0:
				block.remaining_pushs = -1
			else:
				block.remaining_pushs -= 1
				move_tween.tween_callback(func(): block.extend_block(off, direction if not reverse else get_opposite_direction(direction), true))

	if tween_property != "" and not push:
		tween.tween_property(self, tween_property, val, move_speed).set_ease(Tween.EASE_OUT)
		slide_audio.play()

	tween_transition.tween_callback(set_is_moving_to_false).set_delay(move_speed)
	_update_scale_handles()

func _on_scale_handle_dragged(handle: ScaleHandle, direction: Direction):
	if is_moving or not is_selected:
		return

	var variation = get_variation(direction)
	if abs(variation) < 8:
		return

	if variation > 0:
		variation = 16
	else:
		variation = -16
	
	extend_block(variation, direction, false)
