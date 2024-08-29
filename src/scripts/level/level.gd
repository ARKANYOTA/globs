extends Node2D
class_name Level

var block_data = preload("res://scripts/block/block_data.gd")

var actions: Array = []

func _ready():
	actions = []

func is_multiple_os_8_plus_16n(i: int):
	return (i+8)%16 == 0

func is_on_good_position(block: Block):
	for i in [block.position.x, block.position.y, block.up_extend_value, block.down_extend_value, block.right_extend_value, block.left_extend_value]:
		if not is_multiple_os_8_plus_16n(i):
			return false
	return true
	
	
func go_to_next_actions():
	var dico = {}
	for child in $".".get_children():
		if child is Block:
			if not is_on_good_position(child):
				return
			dico[child] = block_data.new(child)
	actions.append(dico)

	
func undo_action():
	if len(actions) == 0:
		return
	else:
		var toundo_actions = actions.pop_back()
		for block in toundo_actions.keys():
			var toundo_action_on_this_block = toundo_actions[block]
			block.position = toundo_action_on_this_block.position
			block.up_extend_value = toundo_action_on_this_block.up_extend_value
			block.down_extend_value = toundo_action_on_this_block.down_extend_value
			block.right_extend_value = toundo_action_on_this_block.right_extend_value
			block.left_extend_value = toundo_action_on_this_block.left_extend_value
			block.gravity_axis = toundo_action_on_this_block.gravity_axis
			block.default_gravity_axis = toundo_action_on_this_block.default_gravity_axis

	
