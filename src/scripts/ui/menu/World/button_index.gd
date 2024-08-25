extends Button

var index: int = 0
var can_click: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:

	var world_select = get_node("/root/WorldSelect")
	if world_select:
		world_select.world_index = index
		world_select.change_world(index, false)
	pass # Replace with function body.



func _on_area_2d_mouse_exited() -> void:
	can_click = false
	pass # Replace with function body.

func _on_area_2d_mouse_entered() -> void:
	can_click = true
	pass # Replace with function body.
