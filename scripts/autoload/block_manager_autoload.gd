extends Node

var selected_block_count: int = 0
var current_selected_block: Block = null
var selection_candidates = []
var is_dragging = false

var block_manager: PackedScene = preload("res://scenes/block/block_manager.tscn")
var block_manager_instance: Node

var blocks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()
	
	block_manager_instance = block_manager.instantiate()
	add_child(block_manager_instance)
	var root = get_tree().get_root()
	for child in root.get_children():
		if child.name == "BlockManagerAutoload":
			var root2 = child
			for child2 in root2.get_children():
				print("is in the blockmanagerautoload")
				print(child2.name)
		print(child.name)
	
	print("Block manager autoloaded.")

func reset():
	selected_block_count = 0
	current_selected_block = null
	is_dragging = false
	selection_candidates = []
	blocks = []

func register_block(block: Block):
	blocks.append(block)

func on_select_block(block: Block):
	selected_block_count += 1
	current_selected_block = block
	
	#for block_node in blocks:
		#if block_node != block:
			#block_node.hide_direction_indicator()

func on_unselect_block(block: Block):
	selected_block_count -= 1
	
	#for block_node in blocks:
		#if block_node != block:
			#block_node.show_direction_indicator()

func start_drag():
	is_dragging = true

func end_drag():
	is_dragging = false

func new_selection_candidate(block: Block):
	selection_candidates.append(block)

func can_select(block: Block):
	return true

##################################################

func _unselect_non_selected_blocks():
	var root: Node = get_tree().get_root()
	# if not current_level:
	# 	print("No current level")
	# 	return
	for child in blocks:
		if child != current_selected_block:
			child.unselect()

func _select_selection_candidate():
	if is_dragging or selection_candidates.is_empty():
		return
	
	for candidate in selection_candidates:
		candidate.select()
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_unselect_non_selected_blocks()
	_select_selection_candidate()
	
	selection_candidates.clear()
