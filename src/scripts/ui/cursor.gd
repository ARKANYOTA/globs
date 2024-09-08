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

var cursor_mode: CursorMode = BLOCK_SELECT
var selection: Block = null
var has_cursor_moved = false

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
	var movement_vector := Input.get_vector("game_left", "game_right", "game_up", "game_down", joystick_deadzone)

	if movement_vector.length_squared() >= joystick_deadzone*joystick_deadzone:
		if not has_cursor_moved:
			var block := find_next_block(movement_vector)
			print("block ", block)
			if block:
				has_cursor_moved = true
				select(block)
	else:
		if has_cursor_moved:
			has_cursor_moved = false
