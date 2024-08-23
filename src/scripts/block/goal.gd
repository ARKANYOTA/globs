@tool
extends Area2D
class_name Goal

@onready var nine_patch = $NinePatch
@onready var collision_shape = $CollisionShape

var size_pixels: Vector2
var overlapping_bodies = Dictionary()
@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16
		$NinePatch.position = -size_pixels/2
		$NinePatch.size = size_pixels

func _ready():
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size = Vector2(size_pixels) - Vector2(2,2)
	collision_shape.position = Vector2(0,0)

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return
	
	#for body in overlapping_bodies.keys():
		#if body is Block and body.is_main_character:
			#var body_extents = body.get_node("CollisionShape").shape.extents
			#var goal_extents = collision_shape.shape.extents
			#var body_rect = Rect2(body.global_position - body_extents, body_extents * 2)
			#var goal_rect = Rect2(     global_position - goal_extents, goal_extents * 2)
			#var expanded_goal_rect = Rect2(goal_rect.position - Vector2(8, 8), goal_rect.size + Vector2(8, 8))
			#
			#print("expanded_goal_rect ", expanded_goal_rect)
			#print("body_rect ", body_rect)
			#if goal_rect.encloses(body_rect):
				#print("You win!")


func _on_body_entered(body):
	overlapping_bodies[body] = true
	
	if body is Block and body.is_main_character:
		win()

func win():
	GameManager.win()

func _on_body_exited(body):
	overlapping_bodies.erase(body)


func _on_area_entered(area: Area2D) -> void:
	overlapping_bodies[area] = true
	
	if area is Block and area.is_main_character:
		win()
