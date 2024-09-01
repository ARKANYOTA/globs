extends AnimatedSprite2D

@export var x_offset: int = 0
@export var y_offset: int = 0
@onready var block : Block = get_parent()
var extend_list : Array = []
@export var props_direction : Block.Direction = Block.Direction.UP
var props_position : Vector2 = Vector2(0, 0)
var extend_value_to_remove = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if props_direction == Block.Direction.INVALID:
		visible = false
		return
	if props_direction == Block.Direction.UP:
		y_offset = -y_offset - 16
	elif props_direction == Block.Direction.LEFT:
		x_offset = -x_offset - 16
	elif props_direction == Block.Direction.DOWN:
		y_offset = y_offset + 16
	elif props_direction == Block.Direction.RIGHT:
		x_offset = x_offset + 16
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if props_direction == Block.Direction.INVALID:
		visible = false
		return
	visible = true
	position = Vector2(x_offset, y_offset)
	position = add_extend_value(props_direction, position)
	
	pass

func add_extend_value(direction: Block.Direction, pos: Vector2):
	if direction == Block.Direction.UP:
		pos.y -= block.get_extend_value(Block.Direction.UP) - extend_value_to_remove
	elif direction == Block.Direction.LEFT:
		pos.x -= block.get_extend_value(Block.Direction.LEFT) - extend_value_to_remove
	elif direction == Block.Direction.DOWN:
		pos.y += block.get_extend_value(Block.Direction.DOWN) - extend_value_to_remove
	elif direction == Block.Direction.RIGHT:
		pos.x += block.get_extend_value(Block.Direction.RIGHT) - extend_value_to_remove
	return pos
