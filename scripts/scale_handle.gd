@tool
extends ClickArea
class_name ScaleHandle

@export var direction: Block.Direction

func debug_set_label(text: String):
	$Control/Label.text = text

func _process(delta):
	pass
	#$Control/Label.text = str(is_hovered)[0]
