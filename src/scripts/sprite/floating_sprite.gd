@tool
extends Area2D

@export var amplitude = Vector2(0.0, 2.0)
@export var frequency = Vector2(1.0, 1.0)
@export var float_offset = Vector2(0.0, 0.0)
@export var texture: Texture2D:
	set(value):
		texture = value
		$Sprite2D.texture = value

@onready var sprite = $Sprite2D

var float_t = Vector2(0.0, 0.0)
var float_val = Vector2(0.0, 0.0)

var is_mouse_in: bool = false
var mouse_offset := Vector2(0, 0)
var mouse_offset_target := Vector2(0, 0)

func _ready():
	if Engine.is_editor_hint():
		return

	float_val = Vector2(float_offset)


func _process(delta):
	if Engine.is_editor_hint():
		return

	float_t.x = fmod(float_t.x + delta * frequency.x, TAU)
	float_t.y = fmod(float_t.y + delta * frequency.y, TAU)
	float_val.x = sin(float_t.x) * amplitude.x
	float_val.y = sin(float_t.y) * amplitude.y

	if is_mouse_in:
		mouse_offset_target = -get_local_mouse_position()
	else:
		mouse_offset_target = Vector2(0, 0)
	
	mouse_offset += (mouse_offset_target - mouse_offset) * clamp(delta, 0.0, 1.0)

	sprite.position = float_val + mouse_offset


func _on_mouse_entered():
	if Engine.is_editor_hint():
		return

	is_mouse_in = true

func _on_mouse_exited():
	if Engine.is_editor_hint():
		return

	is_mouse_in = false