extends Node

func angle_difference(x: float, y: float) -> float:
	x = fmod(x, TAU)
	y = fmod(y, TAU)
	return fmod(y - x + PI, TAU) - PI

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
