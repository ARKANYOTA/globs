extends Node

var selected_block_count: int = 0
var current_selected_block: Block = null

var block_manager: PackedScene = preload("res://scenes/block_manager.tscn")
var block_manager_instance: Node

var blocks = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	#print tree structure
	print("Block manager autoloaded.")
	pass # Replace with function body.

func register_block(block: Block):
	blocks.append(block)

func on_select_block(block: Block):
	selected_block_count += 1
	current_selected_block = block
	
	for block_node in blocks:
		if block_node != block:
			block_node.hide_direction_indicator()

func on_unselect_block(block: Block):
	selected_block_count -= 1
	
	for block_node in blocks:
		if block_node != block:
			block_node.show_direction_indicator()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
