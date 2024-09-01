extends AnimatedSprite2D

@export var x_offset: int = 10
@export var y_offset: int = 10
@onready var block : Block = get_parent()
var extend_list : Array = []
@export var props_initial_direction : Block.Direction = Block.Direction.UP
var props_direction : Block.Direction = Block.Direction.UP
var props_position : Vector2 = Vector2(0, 0)
var extend_value_to_remove = 8
var new_offset = Vector2(0, 0)
var list_direction = [Block.Direction.UP, Block.Direction.LEFT, Block.Direction.DOWN, Block.Direction.RIGHT]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	props_initial_direction = list_direction.find(props_initial_direction)
	if props_initial_direction == Block.Direction.INVALID:
		visible = false
		return
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if props_initial_direction == Block.Direction.INVALID:
		visible = false
		return
	visible = true
	change_props_gravity()
	position = new_offset
	position = add_extend_value(props_direction, position)
	pass

func add_extend_value(direction: Block.Direction, pos: Vector2):
	if direction == list_direction.find(Block.Direction.UP):
		pos.y -= block.get_extend_value(Block.Direction.UP) - extend_value_to_remove
	elif direction == list_direction.find(Block.Direction.LEFT):
		pos.x -= block.get_extend_value(Block.Direction.LEFT) - extend_value_to_remove
	elif direction == list_direction.find(Block.Direction.DOWN):
		pos.y += block.get_extend_value(Block.Direction.DOWN) - extend_value_to_remove
	elif direction == list_direction.find(Block.Direction.RIGHT):
		pos.x += block.get_extend_value(Block.Direction.RIGHT) - extend_value_to_remove
	return pos

func change_props_gravity():
	props_direction = props_initial_direction
	var axis = block.gravity_axis
	var index_of_axis = list_direction.find(axis)
	var axis_change_list = [2,3,0,1]
	var offset_change_list = [Vector2(-y_offset, -x_offset),
							  Vector2(-y_offset, x_offset),
							  Vector2(x_offset, y_offset),
							  Vector2(y_offset, -x_offset), 
							]
	props_direction = (props_initial_direction + axis_change_list[index_of_axis]) % 4
	if axis == Block.Direction.RIGHT:
		rotation_degrees = -90
	elif axis == Block.Direction.DOWN:
		rotation_degrees = 0
	elif axis == Block.Direction.LEFT:
		rotation_degrees = 90
	elif axis == Block.Direction.UP:
		rotation_degrees = 180
	set_custom_offset(offset_change_list[index_of_axis])
	

func set_custom_offset(vector):
	new_offset = Vector2(0, 0)
	if props_direction == list_direction.find(Block.Direction.UP):
		new_offset.y = -vector.y - 16
		new_offset.x = vector.x
	elif props_direction == list_direction.find(Block.Direction.LEFT):
		new_offset.x = -vector.x - 16
		new_offset.y = vector.y
	elif props_direction == list_direction.find(Block.Direction.DOWN):
		new_offset.y = vector.y + 16
		new_offset.x = vector.x
	elif props_direction == list_direction.find(Block.Direction.RIGHT):
		new_offset.x = vector.x + 16
		new_offset.y = vector.y