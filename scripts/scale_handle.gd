@tool
extends ClickArea
class_name ScaleHandle

@export var direction: Block.Direction

@onready var main := get_node("/root/Main")
@onready var block_manager: BlockManager = get_node("/root/Main/BlockManager")
@onready var sprite: Sprite2D = $Sprite

func hide_handle():
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)

func show_handle():
	show()
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)
