extends Node2D

var block: Block
var direction: Block.Direction
var is_held: bool = false
var extend_value: float = 0
var extend_range: Vector2i

var base_indicator_pos: Vector2
var final_indicator_pos: Vector2

var is_extended = false
var is_highlighted = false

var texture_retracted: Texture2D = preload("res://assets/images/ui/direction_indicator.png")
var texture_extended: Texture2D = preload("res://assets/images/ui/extent_indicator.png")
var texture_highlighted: Texture2D = preload("res://assets/images/ui/extent_indicator_highlighted.png")

var dotted_line_texture_normal: Texture2D = preload("res://assets/images/ui/dotted_line.png")
var dotted_line_texture_highlighted: Texture2D = preload("res://assets/images/ui/dotted_line_highlighted.png")

@onready var preview_line: Line2D = $PreviewLine
@onready var arrow_sprite: Sprite2D = $ArrowSprite

func initialize():
	_update_extend_values()
	_update_base_and_final_offsets()
	
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
	var dir_offset = Util.direction_to_vector(direction)
	var center = block.get_center()
	var dimensions = block.get_dimensions()
	
	base_indicator_pos = center + (dimensions / 2) * dir_offset
	final_indicator_pos = base_indicator_pos + dir_offset * (extend_range.y - extend_value)

func set_highlighted(val):
	is_highlighted = val
	if is_highlighted:
		arrow_sprite.texture = texture_highlighted
		preview_line.texture = dotted_line_texture_highlighted
	else:
		preview_line.texture = dotted_line_texture_normal

func retract_indicator():
	is_extended = false
	arrow_sprite.texture = texture_retracted

	preview_line.hide()
	set_highlighted(false)

	#tween.tween_callback(hide)

func extend_indicator():
	is_extended = true
	arrow_sprite.texture = texture_extended
	preview_line.show()
	show()

func hide_indicator():
	hide()

func show_indicator():
	show()

func _ready():
	var rot = Util.direction_to_rotation(direction)
	arrow_sprite.rotation = rot

	retract_indicator()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_update_extend_values()
	_update_base_and_final_offsets()
	
	if is_extended:
		var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(arrow_sprite, "position", final_indicator_pos, 0.3).set_ease(Tween.EASE_OUT)
	else:
		var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(arrow_sprite, "position", base_indicator_pos, 0.3).set_ease(Tween.EASE_OUT)

	preview_line.points[0] = floor(base_indicator_pos)
	preview_line.points[1] = floor(final_indicator_pos)
