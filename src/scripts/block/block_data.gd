extends Node
class_name BlockData

var position
var up_extend_value
var down_extend_value
var right_extend_value
var left_extend_value
var default_gravity_axis
var gravity_axis


func _init(child: Block):
	position = child.position
	up_extend_value = child.up_extend_value
	down_extend_value = child.down_extend_value
	right_extend_value = child.right_extend_value
	left_extend_value = child.left_extend_value
	default_gravity_axis = child.default_gravity_axis
	gravity_axis = child.gravity_axis
	
func _to_string():
	return "["+str(position)+",("+str(up_extend_value)+", "+str(down_extend_value)+","+str(right_extend_value)+","+str(left_extend_value)+")]"
