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

var texture_normal = preload("res://assets/images/ui/handle.png")
var texture_hover = preload("res://assets/images/ui/handle_hover.png")
var texture_pressed = preload("res://assets/images/ui/handle_pressed.png")

func initialize():
	pass

func hide_handle():
	is_enabled = false
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		sprite.hide()
		collision_shape.hide()
	)


func show_handle():
	is_enabled = true
	
	sprite.show()
	collision_shape.show()
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)

func _process(delta):
	super._process(delta)
	
	if is_held:
		sprite.texture = texture_pressed
	elif is_hovered:
		sprite.texture = texture_hover
	else:
		sprite.texture = texture_normal
