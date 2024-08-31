extends Node
class_name BlockData

var position
var up_extend_value
var down_extend_value
var right_extend_value
var left_extend_value
var default_gravity_axis
var gravity_axis
var time_left
var is_visible

func _init(child: Block):
	position = child.position
	up_extend_value = child.up_extend_value
	down_extend_value = child.down_extend_value
	right_extend_value = child.right_extend_value
	left_extend_value = child.left_extend_value
	default_gravity_axis = child.default_gravity_axis
	gravity_axis = child.gravity_axis
	time_left = child.time_left
	is_visible = child.is_visible()

func gravity_axis_str(axis):
	match (axis):
		Block.Direction.LEFT:
			return "LEFT"
		Block.Direction.RIGHT:
			return "RIGHT"
		Block.Direction.UP:
			return "UP"
		Block.Direction.DOWN:
			return "DOWN"
		_:
			return "?"

func _to_string():
	return "[\n"+str(position)+",("+str(up_extend_value)+", "+str(down_extend_value)+","+str(right_extend_value)+","+str(left_extend_value)+",\n"+gravity_axis_str(default_gravity_axis)+", "+gravity_axis_str(gravity_axis)+", \n"+str(is_visible)+")]\n"
