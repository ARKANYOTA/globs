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


func _process(_delta):
	#_unselect_non_selected_blocks()
	#_select_selection_candidate()
	
	selection_candidates.clear()
