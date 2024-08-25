extends Node2D
class_name Level

var BlockData = preload("res://scripts/block/block_data.gd")

var actions: Array = []
var current_action = 0

func _ready():
	actions = []
	current_action = -1


func go_to_next_actions():
	current_action += 1
	if len(actions) <= current_action:
		actions.append({})
	
	for child in $".".get_children():
		if child is Block:
			actions[current_action][child] = BlockData.new(child)

	
func undo_action():
	if current_action <= -1:
		current_action = -1
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
		current_action -= 1

	
