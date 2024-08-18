extends Node

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
