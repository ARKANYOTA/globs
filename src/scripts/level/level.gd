extends Node2D
class_name Level

var block_data = preload("res://scripts/block/block_data.gd")

var actions: Array = []

func _ready():
	actions = []

func is_multiple_of_8_plus_16n(i: float):
	var value = fmod((i + 8.0), 16.0)
	return value + 1.0 < 1.1 and value + 1.0 > 0.9

func is_on_good_position(block: Block):
	for i in [block.position.x, block.position.y, block.up_extend_value, block.down_extend_value, block.right_extend_value, block.left_extend_value]:
		if not is_multiple_of_8_plus_16n(i):
			return false
	return true
	
	
func go_to_next_actions():
	var dico = {}
	for child in $".".get_children():
		if child is Block and child.is_visible():
			if not is_on_good_position(child):
				return
			dico[child] = block_data.new(child)
	actions.append(dico)

func upgrade_time_to_everyone(block: Block):
	for child in $".".get_children():
		if child is Block and child.is_visible():
			if child.time_left != 0:
				if child.is_time_global or ((not child.is_time_global) and child==block):
					child.time_left -= 1
					if child.time_left == 0:
						child.hide()

	
func undo_action():
	if len(actions) == 0:
		return
	else:
		var toundo_actions = actions.pop_back()
		for block in toundo_actions.keys():
			if block == null:
				continue
			for tween in block.tween_list:
				if tween != null:
					tween.kill()
			block.is_moving = false
			block.is_falling = false
			var toundo_action_on_this_block = toundo_actions[block]
			if toundo_action_on_this_block.is_visible:
				block.show()
			else:
				block.hide()

			block.position = toundo_action_on_this_block.position
			block.up_extend_value = toundo_action_on_this_block.up_extend_value
			block.down_extend_value = toundo_action_on_this_block.down_extend_value
			block.right_extend_value = toundo_action_on_this_block.right_extend_value
			block.left_extend_value = toundo_action_on_this_block.left_extend_value
			block.default_gravity_axis = toundo_action_on_this_block.default_gravity_axis
			block.gravity_axis = toundo_action_on_this_block.gravity_axis
			block.time_left = toundo_action_on_this_block.time_left


	
