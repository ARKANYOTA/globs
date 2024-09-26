extends Camera2D

var list_globs = []
var tween: Tween
var selected_glob: Block
func _ready() -> void:
	make_current()
	for child in get_tree().get_nodes_in_group("Blocks"):
		if child is Block:
			list_globs.append(child)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for glob in list_globs:
		if glob.is_selected and selected_glob != glob:
			selected_glob = glob
			reparent(glob)
			tween = create_tween().set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(self, "position", Vector2(0,0), 0.5).set_ease(Tween.EASE_IN_OUT)
			make_current()
	pass
