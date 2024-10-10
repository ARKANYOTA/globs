extends Node2D

class_name ScrollComponent

var is_dragging = false
var mouse_start_click_position = Vector2()
var mouse_click_position = Vector2()
var delta_mouse_position = Vector2()
var mouse_unclick_position = Vector2()
var delta_max = 32
var world_screen_size = Vector2(0,0)

# make a const
const sus_globs_achievements_gap = 0.60
@export var world_select : WorldSelect

func _ready():
	#SCOTCH JE SAIS PAS COMMENT AVOIR LA SIZE DU VIEWPORT
	# world_screen_size = get_viewport().size
	world_screen_size = 240
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_dragging = true
			mouse_click_position = event.position
		else:
			if is_dragging == false:
				return
			is_dragging = false
			delta_mouse_position = Vector2()
			mouse_unclick_position = event.position
			if (mouse_click_position.x - mouse_unclick_position.x) > delta_max:
				world_select.increment_world_index(false)
			elif (mouse_click_position.x - mouse_unclick_position.x) < -delta_max:
				world_select.decrement_world_index(false)
			else:
				world_select.restore_position()
			pass
	elif event is InputEventMouseMotion:
		if is_dragging:
			var delta = event.relative
			delta_mouse_position += delta
			for child in get_children():
				child.position.x += delta.x
			handle_sus_globs_achievements()

func handle_sus_globs_achievements() -> void:
	var screen_gap = world_screen_size * sus_globs_achievements_gap
	var my_sign = 0

	if world_select.world_index == 0:
		my_sign = 1
	if world_select.world_index == world_select.world.size() - 1:
		my_sign = -1

	if (my_sign != 0 && my_sign * delta_mouse_position.x > screen_gap):
		if GameManager.achievement_manager:
			GameManager.achievement_manager.grant("ACH_SECRET_WORLD_SELECT")
