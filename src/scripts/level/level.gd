extends Node2D
class_name Level

var block_data = preload("res://scripts/block/block_data.gd")

var last_awake_block: Block
var awake_count: int
var num_globs_hidden = 0

var actions: Array = []

func _ready():
	actions = []
	GameManager.on_globs_hidden.connect(_on_globs_hidden)

func _on_globs_hidden(block: Block):
	num_globs_hidden += 1


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
			if child.is_falling or child.is_moving:
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

func can_undo() -> bool:
	for elt in get_children():
		if elt is Block:
			if elt.is_moving or elt.is_falling:
				return false
	return len(actions) > 0

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
				if block.visible == false:
					num_globs_hidden -= 1
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

# Awake
func add_awake_block(block: Block):
	if last_awake_block == null:
		last_awake_block = block
		awake_count = 1
		return
	if not (last_awake_block == block):
		last_awake_block = block
		awake_count = 1
		return 
	if awake_count == null:
		awake_count = 0
	awake_count += 1
	if awake_count == 5:
		if GameManager == null:
			return
		if GameManager.achievement_manager == null:
			return
		GameManager.achievement_manager.grant("ACH_WAKEY_WAKEY")
		
	
