extends Node2D
class_name BlockManager

@onready var main = get_node("/root/Main")

var selected_block_count: int = 0
var current_selected_block: Block = null
var is_dragging: bool = false
var selection_candidates = []

func start_drag():
	is_dragging = true

func end_drag():
	is_dragging = false

func new_selection_candidate(block: Block):
	selection_candidates.append(block)

func can_select(block: Block):
	return true

func on_select_block(block: Block):
	selected_block_count += 1
	
	current_selected_block = block

func on_unselect_block(block: Block):
	selected_block_count -= 1

##################################################

func _unselect_non_selected_blocks():
	var root: Node = get_tree().get_root()
	# if not current_level:
	# 	print("No current level")
	# 	return
	for child in root.get_children():
		if child is Block:
			if child != current_selected_block:
				child.unselect()

func _select_selection_candidate():
	if is_dragging or selection_candidates.is_empty():
		return
	
	for candidate in selection_candidates:
		candidate.select()
		return

func _process(delta):
	_unselect_non_selected_blocks()
	_select_selection_candidate()
	
	selection_candidates.clear()
