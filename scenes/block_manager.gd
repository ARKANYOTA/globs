extends Node2D
class_name BlockManager

@onready var main = get_node("/root/Main")

var selected_block_count: int = 0

func can_select_block(block: Block) -> bool:
	return (selected_block_count <= 0)

func on_select_block(block: Block):
	selected_block_count += 1
	
	var current_level: Node = main.current_scene_node
	if not current_level:
		return
	
	for child in current_level.get_children():
		if child is Block:
			child.unselect()

func on_unselect_block(block: Block):
	selected_block_count -= 1

func _process(delta):
	pass
