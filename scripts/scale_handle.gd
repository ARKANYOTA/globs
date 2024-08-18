@tool
extends ClickArea
class_name ScaleHandle

@export var block: Block
@export var direction: Block.Direction
@export var extend_range: Vector2i
@export var extend_value: float

@onready var main := get_node("/root/Main")
@onready var block_manager: BlockManager = get_node("/root/Main/BlockManager")
@onready var collision_shape: CollisionShape2D = $ClickAreaCollisionShape
@onready var sprite: Sprite2D = $Sprite


func initialize():
	var offset = Util.direction_to_vector(direction)
	var rot = Util.direction_to_rotation(direction)

func hide_handle():
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		sprite.hide()
		collision_shape.hide()
	)


func show_handle():
	sprite.show()
	collision_shape.show()
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)

func _process(delta):
	super._process(delta)
