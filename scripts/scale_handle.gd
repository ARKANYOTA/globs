@tool
extends ClickArea
class_name ScaleHandle

@export var direction: Block.Direction

@onready var sprite: Sprite2D = $Sprite
@onready var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC)

func hide_handle():
	hide()

func show_handle():
	show()
