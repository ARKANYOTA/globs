extends Node2D

@export var tween_speed := 0.2
@export var select_offset := Vector2(6, 6.5)
@export var joystick_deadzone := 0.3
@export var raycast_range := 600
@export_range(-360, 360, 0.001, "radians_as_degrees") var max_angle_range := PI/2
@export_flags_2d_physics var raycast_collision_mask: int

enum CursorMode {
	BLOCK_SELECT,
	DIRECTION_SELECT, 
}

var cursor_mode: CursorMode = CursorMode.BLOCK_SELECT
var selection: Block = null
var has_cursor_moved = false
var selected_direction: Block.Direction = Block.Direction.INVALID

func _ready():
	pass 

func deselect():
	selection = null
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, tween_speed).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)


func select(block: Block):
	selection = block

	show()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "position", block.position + select_offset, tween_speed).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, tween_speed).set_ease(Tween.EASE_OUT)
	
func find_next_block(direction_vector: Vector2) -> Block:
	# TODO: make it based on the closest Glob rather than the closest in direction
	var origin_angle = direction_vector.angle()
	var space_state = get_world_2d().direct_space_state

	var step: float = PI/30
	var i_angle = 0
	while i_angle <= max_angle_range:
		for s in [-1, 1]:
			var ray_angle = origin_angle + i_angle * s
			# print(rad_to_deg(ray_angle))
			var ray_vector = Vector2.from_angle(ray_angle) * raycast_range
			var query = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_vector, raycast_collision_mask, [self])
			query.collide_with_areas = true
			query.collide_with_bodies = false

			var result: Dictionary = space_state.intersect_ray(query)
			if result.has("collider"):
				var collider = result["collider"]
				if collider and (collider is Block) and collider != selection:
					return collider
		
		i_angle += step
	
	return null


func _physics_process(delta):
	var joystick_vector := Input.get_vector("game_left", "game_right", "game_up", "game_down", joystick_deadzone)
	if joystick_vector.length_squared() >= joystick_deadzone*joystick_deadzone:
		joystick_vector = Vector2.ZERO

	match cursor_mode:
		CursorMode.BLOCK_SELECT:
			if not joystick_vector.is_zero_approx():
				if not has_cursor_moved:
					var block := find_next_block(joystick_vector)
					if block:
						has_cursor_moved = true
						select(block)
			else:
				if has_cursor_moved:
					has_cursor_moved = false
		
		CursorMode.DIRECTION_SELECT:
			if not selection:
				return

			if not joystick_vector.is_zero_approx():
				var joystick_angle = joystick_vector.angle()
				var directions = selection.get_extendable_directions()
				var closest_direction = Util.closest_direction_to_angle(joystick_angle, directions)
				if closest_direction != Block.Direction.INVALID:
					selected_direction = closest_direction

		_:
			pass

func _input(event):
	match cursor_mode:
		CursorMode.BLOCK_SELECT:
			if event.is_action_pressed("select"):
				cursor_mode = CursorMode.DIRECTION_SELECT
				selected_direction = Block.Direction.INVALID
		
		CursorMode.DIRECTION_SELECT:
			if selection and selected_direction != Block.Direction.INVALID: 
				if event.is_action_pressed("grow"):
					selection.extend_block(16, selected_direction, false)
				if event.is_action_pressed("shrink"):
					selection.extend_block(-16, selected_direction, false)
			