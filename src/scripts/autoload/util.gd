extends Node

const err_to_str_map = {
	Error.OK: "OK",
	Error.FAILED: "FAILED",
	Error.ERR_UNAVAILABLE: "ERR_UNAVAILABLE",
	Error.ERR_UNCONFIGURED: "ERR_UNCONFIGURED",
	Error.ERR_UNAUTHORIZED: "ERR_UNAUTHORIZED",
	Error.ERR_PARAMETER_RANGE_ERROR: "ERR_PARAMETER_RANGE_ERROR",
	Error.ERR_OUT_OF_MEMORY: "ERR_OUT_OF_MEMORY",
	Error.ERR_FILE_NOT_FOUND: "ERR_FILE_NOT_FOUND",
	Error.ERR_FILE_BAD_DRIVE: "ERR_FILE_BAD_DRIVE",
	Error.ERR_FILE_BAD_PATH: "ERR_FILE_BAD_PATH",
	Error.ERR_FILE_NO_PERMISSION: "ERR_FILE_NO_PERMISSION",
	Error.ERR_FILE_ALREADY_IN_USE: "ERR_FILE_ALREADY_IN_USE",
	Error.ERR_FILE_CANT_OPEN: "ERR_FILE_CANT_OPEN",
	Error.ERR_FILE_CANT_WRITE: "ERR_FILE_CANT_WRITE",
	Error.ERR_FILE_CANT_READ: "ERR_FILE_CANT_READ",
	Error.ERR_FILE_UNRECOGNIZED: "ERR_FILE_UNRECOGNIZED",
	Error.ERR_FILE_CORRUPT: "ERR_FILE_CORRUPT",
	Error.ERR_FILE_MISSING_DEPENDENCIES: "ERR_FILE_MISSING_DEPENDENCIES",
	Error.ERR_FILE_EOF: "ERR_FILE_EOF",
	Error.ERR_CANT_OPEN: "ERR_CANT_OPEN",
	Error.ERR_CANT_CREATE: "ERR_CANT_CREATE",
	Error.ERR_QUERY_FAILED: "ERR_QUERY_FAILED",
	Error.ERR_ALREADY_IN_USE: "ERR_ALREADY_IN_USE",
	Error.ERR_LOCKED: "ERR_LOCKED",
	Error.ERR_TIMEOUT: "ERR_TIMEOUT",
	Error.ERR_CANT_CONNECT: "ERR_CANT_CONNECT",
	Error.ERR_CANT_RESOLVE: "ERR_CANT_RESOLVE",
	Error.ERR_CONNECTION_ERROR: "ERR_CONNECTION_ERROR",
	Error.ERR_CANT_ACQUIRE_RESOURCE: "ERR_CANT_ACQUIRE_RESOURCE",
	Error.ERR_CANT_FORK: "ERR_CANT_FORK",
	Error.ERR_INVALID_DATA: "ERR_INVALID_DATA",
	Error.ERR_INVALID_PARAMETER: "ERR_INVALID_PARAMETER",
	Error.ERR_ALREADY_EXISTS: "ERR_ALREADY_EXISTS",
	Error.ERR_DOES_NOT_EXIST: "ERR_DOES_NOT_EXIST",
	Error.ERR_DATABASE_CANT_READ: "ERR_DATABASE_CANT_READ",
	Error.ERR_DATABASE_CANT_WRITE: "ERR_DATABASE_CANT_WRITE",
	Error.ERR_COMPILATION_FAILED: "ERR_COMPILATION_FAILED",
	Error.ERR_METHOD_NOT_FOUND: "ERR_METHOD_NOT_FOUND",
	Error.ERR_LINK_FAILED: "ERR_LINK_FAILED",
	Error.ERR_SCRIPT_FAILED: "ERR_SCRIPT_FAILED",
	Error.ERR_CYCLIC_LINK: "ERR_CYCLIC_LINK",
	Error.ERR_INVALID_DECLARATION: "ERR_INVALID_DECLARATION",
	Error.ERR_DUPLICATE_SYMBOL: "ERR_DUPLICATE_SYMBOL",
	Error.ERR_PARSE_ERROR: "ERR_PARSE_ERROR",
	Error.ERR_BUSY: "ERR_BUSY",
	Error.ERR_SKIP: "ERR_SKIP",
	Error.ERR_HELP: "ERR_HELP",
	Error.ERR_BUG: "ERR_BUG",
	Error.ERR_PRINTER_ON_FIRE: "ERR_PRINTER_ON_FIRE",
}

func angle_difference(x: float, y: float) -> float:
	x = fmod(x, TAU)
	y = fmod(y, TAU)
	return fmod(y - x + PI, TAU) - PI


func _snap_vector_to_cardinal(vec: Vector2) -> Vector2:
	# https://www.reddit.com/r/godot/comments/t206my/how_to_get_a_direction_from_a_vector2d/
	return Vector2.RIGHT.rotated(round(vec.angle() / TAU * 4) * TAU / 4).snapped(Vector2.ONE)

func snap_vector_to_direction(vec: Vector2) -> Block.Direction:
	var dir_vec = _snap_vector_to_cardinal(vec)
	return Util.vector_to_direction(dir_vec)


func closest_direction_to_angle(source_angle: float, array_directions: Array[Block.Direction]) -> Block.Direction:
	var array_angles: Array[float]
	array_angles.assign(array_directions.map(direction_to_rotation))
	var closest_angle = find_closest_angle(source_angle, array_angles)
	return angle_to_direction(closest_angle)


func find_closest_angle(source_angle: float, array_angles: Array[float]) -> float:
	assert(not array_angles.is_empty(), "Array cannot be empty")
	if array_angles.size() == 1:
		return array_angles[0]

	var shortest_angle: float
	var shortest_diff: float = INF

	for target_angle in array_angles:
		var d = abs(angle_difference(source_angle, target_angle))
		if d < shortest_diff:
			shortest_diff = d
			shortest_angle = target_angle
	
	return shortest_angle


func direction_to_vector(direction: Block.Direction) -> Vector2:
	if direction == Block.Direction.LEFT:
		return Vector2(-1, 0)
	elif direction == Block.Direction.RIGHT:
		return Vector2(1, 0)
	elif direction == Block.Direction.UP:
		return Vector2(0, -1)
	elif direction == Block.Direction.DOWN:
		return Vector2(0, 1)
	return Vector2(0, 0)

func vector_to_direction(vector: Vector2) -> Block.Direction:
	if vector.is_equal_approx(Vector2(-1, 0)):
		return Block.Direction.LEFT
	elif vector.is_equal_approx(Vector2(1, 0)):
		return Block.Direction.RIGHT
	elif vector.is_equal_approx(Vector2(0, -1)):
		return Block.Direction.UP
	elif vector.is_equal_approx(Vector2(0, 1)):
		return Block.Direction.DOWN
	return Block.Direction.INVALID


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

func angle_to_direction(angle: float) -> Block.Direction:
	# angle = fmod(angle, TAU)
	if is_equal_approx(angle, PI):
		return Block.Direction.LEFT
	elif is_equal_approx(angle, 0):
		return Block.Direction.RIGHT
	elif is_equal_approx(angle, -PI/2):
		return Block.Direction.UP
	elif is_equal_approx(angle, PI/2):
		return Block.Direction.DOWN
	return Block.Direction.INVALID

func direction_to_string(direction: Block.Direction) -> String:
	if direction == Block.Direction.LEFT:
		return "left"
	elif direction == Block.Direction.RIGHT:
		return "right"
	elif direction == Block.Direction.UP:
		return "up"
	elif direction == Block.Direction.DOWN:
		return "down"
	elif direction == Block.Direction.INVALID:
		return "invalid"
	return ""


func new_tween(node: Node, transition_type = Tween.TRANS_CUBIC, ease_type = Tween.EASE_IN_OUT) -> Tween:
	return get_tree().create_tween().bind_node(node).set_trans(transition_type).set_ease(ease_type)

func error_to_string(error: Error) -> String:
	if err_to_str_map.has(error):
		return err_to_str_map[error]
	return "[Unknown error]"

func enum_to_string(enum_values, value):
	if value < 0 or value >= enum_values.size():
		return "[Unknown enum value {0}]".format([value])
	return enum_values[value]