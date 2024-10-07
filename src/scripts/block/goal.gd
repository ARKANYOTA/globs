@tool
extends Area2D
class_name Goal

var is_collected = false
var size_pixels: Vector2
var overlapping_bodies = Dictionary()

@export_enum("yellow", "blue", "red", "green") var style: String = "yellow":
	set(value):
		style = value 
		$Sprite.animation = value
@export var do_collect_animation = true
@export var win_time_delay = 1.4
@export var size: Vector2i = Vector2i(1, 1):
	set(value):
		size = value
		size_pixels = Vector2(value) * 16

@onready var collision_shape = $CollisionShape

func _ready():
	$Sprite.animation = style

	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size.x = max(size_pixels.x - 2, 0)
	collision_shape.shape.size.y = max(size_pixels.y - 2, 0)
	collision_shape.position = Vector2(0,0)

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return


func _on_body_entered(body):
	overlapping_bodies[body] = true
	
	if body is Block and body.is_main_character:
		win()

func win():
	if is_collected:
		return
	is_collected = true
	GameManager.start_win_animation()
	
	if do_collect_animation:
		$AnimationPlayer.play("collected")
		$SparkleBurst.emitting = true

		var timer: Timer = $WinDelayTimer
		timer.set_wait_time(win_time_delay)
		timer.start()
		await timer.timeout
	GameManager.win()

func _on_body_exited(body):
	overlapping_bodies.erase(body)


func _on_area_entered(area: Area2D) -> void:
	overlapping_bodies[area] = true
	
	if area is Block and area.is_main_character:
		win()
