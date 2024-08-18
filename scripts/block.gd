@tool
extends CharacterBody2D
class_name Block

enum Direction {
	LEFT, RIGHT, UP, DOWN
}

@export var is_gravity_enabled := true:
	set(value):
		is_gravity_enabled = value
		if value:
			static_block = false
		_update_sprite()

@export var static_block := false:
	set(value):
		static_block = value
		if value:
			is_gravity_enabled = false
		_update_sprite()

@export var is_main_character := false:
	set(value):
		is_main_character = value
		_update_sprite()

@export var rotatable: bool = false
@export_range(-360, 360) var angle: float = 0:
	set(value):
		angle = value
		#$CollisionShape.rotation_degrees = value
		#$Sprite.rotation_degrees = value

@export var scale_max_speed : float = 1.5

@export_group("Up Extandable")
@export var up_extendable: bool = false
@export var up_extend_range: Vector2i = Vector2i(8, 100)
@export var up_extend_value: float = 8:
	set(value):
		up_extend_value = clamp(value, up_extend_range.x, up_extend_range.y)
		update_dimensions()

@export_group("Down Extandable")
@export var down_extendable: bool = false
@export var down_extend_range: Vector2i = Vector2i(8, 100)
@export var down_extend_value: float = 8:
	set(value):
		down_extend_value = clamp(value, down_extend_range.x, down_extend_range.y)
		update_dimensions()

@export_group("Left Extandable")
@export var left_extendable: bool = false
@export var left_extend_range: Vector2i = Vector2i(8, 100)
@export var left_extend_value: float = 8:
	set(value):
		left_extend_value = clamp(value, left_extend_range.x, left_extend_range.y)
		update_dimensions()

@export_group("Right Extandable")
@export var right_extendable: bool = false
@export var right_extend_range: Vector2i = Vector2i(8, 100)
@export var right_extend_value: float = 8:
	set(value):
		right_extend_value = clamp(value, right_extend_range.x, right_extend_range.y)
		update_dimensions()

################################################

@onready var main := get_node("/root/Main")
@onready var sleep_particles: CPUParticles2D = $Sleep/SleepParticles
@onready var click_audio: AudioStreamPlayer2D = $Audio/ClickAudio
@onready var slide_audio: AudioStreamPlayer2D = $Audio/SlideAudio

var is_hovered := false
var is_selected := false
var handles: Array = []
var direction_indicators: Array[Sprite2D] = []
var scale_handle: PackedScene = load("res://scenes/scale_handle.tscn")
var direction_indicator: PackedScene = load("res://scenes/direction_indicator.tscn")

var animation = "o_face"
var is_asleep := false

var extent_targets = {
	"left" = left_extend_value,
	"right" = right_extend_value,
	"up" = up_extend_value,
	"down" = down_extend_value,
}

################################################

func get_extend_value(direction: Direction):
	if direction == Direction.LEFT:
		return left_extend_value
	elif direction == Direction.RIGHT:
		return right_extend_value
	elif direction == Direction.UP:
		return up_extend_value
	elif direction == Direction.DOWN:
		return down_extend_value

func set_extend_value(direction: Direction, value):
	if direction == Direction.LEFT:
		left_extend_value = value
	elif direction == Direction.RIGHT:
		right_extend_value = value
	elif direction == Direction.UP:
		up_extend_value = value
	elif direction == Direction.DOWN:
		down_extend_value = value

func expand(direction: Direction, amount: int):
	if direction == Direction.RIGHT:
		right_extend_value += amount
	if direction == Direction.LEFT:
		left_extend_value += amount
	if direction == Direction.UP:
		up_extend_value += amount
	if direction == Direction.DOWN:
		down_extend_value += amount

func update_dimensions():
	var dim: Vector2 = Vector2(left_extend_value + right_extend_value, 
							   up_extend_value + down_extend_value)
	var collision_shape = $CollisionShape
	var click_area = $ClickArea
	var click_area_collision_shape = $ClickArea/ClickAreaCollisionShape
	var unclick_area_collision_shape = $UnClickArea/ClickAreaCollisionShape
	var shape = collision_shape.shape
	var light_occ : LightOccluder2D = $BlockOccluder

	if shape is not RectangleShape2D:
		print("$CollisionShape.shape is not a RectangleShape2D")
		return
	
	# Update size
	shape.size = dim
	click_area_collision_shape.shape.size = dim
	if light_occ != null:
		light_occ.occluder.polygon = [Vector2(-dim.x/2, -dim.y/2), Vector2(dim.x/2, -dim.y/2), Vector2(dim.x/2, dim.y/2), Vector2(-dim.x/2, dim.y/2)]
	unclick_area_collision_shape.shape.size = dim + Vector2(8, 8)
	
	# Update position
	var child_pos: Vector2 = Vector2(-left_extend_value + right_extend_value,
									 -up_extend_value   + down_extend_value) / 2
	if light_occ != null:
		light_occ.position = child_pos
	collision_shape.position = child_pos
	unclick_area_collision_shape.position = child_pos
	click_area.position = child_pos
	update_sprite_size(child_pos, dim)

func update_sprite_size(_pos, dimensions):
	var nine_patch: NinePatchRect = $NinePatch
	nine_patch.position = round(get_center() - dimensions/2)
	nine_patch.size = round(dimensions)

func select():
	if is_selected:
		return
	
	is_selected = true
	_show_scale_handles()
	extend_direction_indicator()
	BlockManagerAutoload.on_select_block(self)
	
	click_audio.pitch_scale = 1.0
	click_audio.play()

func unselect():
	if not is_selected:
		return
	
	is_selected = false
	_hide_scale_handles()
	retract_direction_indicator()
	BlockManagerAutoload.on_unselect_block(self)
	
	click_audio.pitch_scale = 0.8
	click_audio.play()

func get_dimensions():
	return Vector2(left_extend_value + right_extend_value, up_extend_value + down_extend_value)

func get_center():
	return $CollisionShape.position

################################################

func _update_sprite():
	# Update animation
	_update_animation()
	
	# Change 9-patch sprite
	var ninepatch: NinePatchRect = $NinePatch
	if is_main_character: # Normal
		ninepatch.region_rect.position = Vector2(0, 96)
	elif static_block: # Normal
		ninepatch.region_rect.position = Vector2(16, 80)
	elif is_gravity_enabled: # Gravity
		ninepatch.region_rect.position = Vector2(32, 80)
	#else: # bleu
		#ninepatch.region_rect.position.x = 0
		#ninepatch.region_rect.position.y = 32

func _update_animation():
	var dim = get_dimensions()
	var size = dim.x * dim.y
	var old_animation = animation
	
	if not is_selected:
		animation = "sleeping"
	elif size <= 4*16*16:
		animation = "poker"
	elif size <= 6*16*16:
		animation = "fat"
	else:
		animation = "scared"
	
	if sleep_particles:
		sleep_particles.emitting = (animation == "sleeping")

func _create_scale_handle(direction: Direction, handle_name: String):
	var new_scale_handle: ScaleHandle = scale_handle.instantiate()
	new_scale_handle.block = self
	new_scale_handle.name = handle_name
	new_scale_handle.direction = direction
	new_scale_handle.z_index = 10
	
	new_scale_handle.start_drag.connect(func():
		_on_scale_handle_start_drag(new_scale_handle, direction)
	)
	new_scale_handle.end_drag.connect(func():
		_on_scale_handle_end_drag(new_scale_handle, direction)
	)
	new_scale_handle.dragging.connect(func():
		_on_scale_handle_dragged(new_scale_handle, direction)
	)
	add_child(new_scale_handle)
	new_scale_handle.initialize()
	
	var new_direction_indicator = direction_indicator.instantiate()
	new_direction_indicator.block = self
	new_direction_indicator.direction = direction
	add_child(new_direction_indicator)
	new_direction_indicator.initialize()
	
	handles.append({
		handle = new_scale_handle,
		direction_indicator = new_direction_indicator,
	})

func _create_scale_handles():
	if left_extendable:
		_create_scale_handle(Direction.LEFT, "LeftHandle")
	if right_extendable:
		_create_scale_handle(Direction.RIGHT, "RightHandle")
	if up_extendable:
		_create_scale_handle(Direction.UP, "UpHandle")
	if down_extendable:
		_create_scale_handle(Direction.DOWN, "DownHandle")
	
	_update_scale_handles()

func _update_scale_handles():
	var center = get_center()
	var dimensions = get_dimensions()
	for handle_info in handles:
		var handle = handle_info["handle"]
		var direction = handle.direction
		var handle_position = center + Util.direction_to_vector(direction) * (dimensions/2)
		handle.position = round(handle_position) 
		
		var indicator = handle_info["direction_indicator"]
		indicator.is_held = handle.is_held

func _hide_scale_handles():
	for handle in handles:
		handle["handle"].hide_handle()

func _show_scale_handles():
	for handle in handles:
		handle["handle"].show_handle()

func retract_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].retract_indicator()

func extend_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].extend_indicator()

func hide_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].hide_indicator()

func show_direction_indicator():
	for handle in handles:
		handle["direction_indicator"].show_indicator()


################################################

func _ready():
	$CollisionShape.shape = $CollisionShape.shape.duplicate()
	$ClickArea/ClickAreaCollisionShape.shape = $ClickArea/ClickAreaCollisionShape.shape.duplicate()
	
	if Engine.is_editor_hint():
		return
	
	_update_sprite()
	
	up_extend_value = up_extend_value
	down_extend_value = down_extend_value
	left_extend_value = left_extend_value
	right_extend_value = right_extend_value
	_create_scale_handles()
	_hide_scale_handles()
	
	update_dimensions()
	BlockManagerAutoload.register_block(self)

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	$CenterIndicator.play(animation)

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	velocity.x /= 2
	if is_gravity_enabled:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		const rot_speed = 0.1
		var alpha = fmod(fmod(angle, 90) + 90, 90)
		
		if is_on_floor() and alpha != 0:
			if alpha < 45:
				angle -= alpha * rot_speed
			else:
				angle += alpha * rot_speed
	else:
		velocity.y /= 2
	
	if not static_block:
		move_and_slide()
	
	_update_scale_handles()
	_update_sprite()

func _on_click_area_clicked():
	if BlockManagerAutoload.can_select(self):
		BlockManagerAutoload.new_selection_candidate(self)

func _on_un_click_area_clicked_outside_area():
	unselect()

func _on_scale_handle_start_drag(handle: ScaleHandle, direction: Direction):
	BlockManagerAutoload.start_drag()

func _on_scale_handle_end_drag(handle: ScaleHandle, direction: Direction):
	BlockManagerAutoload.end_drag()

func _on_scale_handle_dragged(handle: ScaleHandle, direction: Direction):
	var pos_diff = Vector2i(get_global_mouse_position() - global_position)
	pos_diff = round((Vector2(pos_diff) + Vector2(8, 8)) / 16) * 16 - Vector2(8, 8)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	
	var val: float
	var tween_property = ""
	if direction == Direction.LEFT:
		val = abs(min(0, pos_diff.x))
		tween_property = "left_extend_value"
	elif direction == Direction.RIGHT:
		val = max(0, pos_diff.x)
		tween_property = "right_extend_value"
	elif direction == Direction.UP:
		val = abs(min(0, pos_diff.y))
		tween_property = "up_extend_value"
	elif direction == Direction.DOWN:
		val = max(0, pos_diff.y)
		tween_property = "down_extend_value"
	
	var old_val = extent_targets[Util.direction_to_string(direction)]
	extent_targets[Util.direction_to_string(direction)] = val
	
	if tween_property != "" and not is_equal_approx(old_val, val):
		tween.tween_property(self, tween_property, val, 0.3).set_ease(Tween.EASE_OUT)
		if not slide_audio.is_playing():
			slide_audio.play()
	
	_update_scale_handles()
