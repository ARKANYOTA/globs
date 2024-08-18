extends Sprite2D

var block: Block
var direction: Block.Direction
var is_held: bool = false
var extend_value: float = 0
var extend_range: Vector2i

var base_indicator_pos: Vector2
var final_indicator_pos: Vector2

func initialize():
	_update_extend_values()
	_update_base_and_final_offsets()
	
	var rot = Util.direction_to_rotation(direction)
	rotation = rot
	
	retract_indicator()

func _update_extend_values():
	if not block:
		return
	
	if direction == Block.Direction.LEFT:
		extend_value = block.left_extend_value
		extend_range = block.left_extend_range
	elif direction == Block.Direction.RIGHT:
		extend_value = block.right_extend_value
		extend_range = block.right_extend_range
	elif direction == Block.Direction.UP:
		extend_value = block.up_extend_value
		extend_range = block.up_extend_range
	elif direction == Block.Direction.DOWN:
		extend_value = block.down_extend_value
		extend_range = block.down_extend_range

func _update_base_and_final_offsets():
	var offset = Util.direction_to_vector(direction)
	base_indicator_pos = offset * (extend_value + 4)
	final_indicator_pos = offset * extend_range.y

func retract_indicator():
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", base_indicator_pos, 0.3).set_ease(Tween.EASE_OUT)
	#tween.tween_callback(hide)

func extend_indicator():
	show()
	
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", final_indicator_pos, 0.3).set_ease(Tween.EASE_OUT)

func hide_indicator():
	hide()

func show_indicator():
	show()

func _ready():
	retract_indicator()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_extend_values()
	_update_base_and_final_offsets()
	
