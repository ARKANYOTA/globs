extends Node2D

var fly = false
#
var vector = Vector2(600 + randf_range(-100, 100), 400 + randf_range(-100, 100))
var speed = randf_range(7, 10)
var random_time = randf_range(10, 20)
func _ready() -> void:
	var stay_timer = Timer.new()
	stay_timer.set_wait_time(random_time)
	stay_timer.timeout.connect(_on_timer_timeout)
	add_child(stay_timer)
	stay_timer.start()
	$Static.play()
	pass

func _on_timer_timeout() -> void:
	fly_bird()

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	#get mouse positionqsd
	fly_bird()
	pass # Replace with function body.

func fly_bird():
	var flying_sound : AudioStreamPlayer = $BirdFlying
	var mouse_position = get_global_mouse_position()
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	if fly:
		return
	flying_sound.play()
	$Static.visible = false
	if mouse_position.x < position.x:
		$AnimatedBirdRight.visible = true
		$AnimatedBirdRight.play("right")
		# position = Vector2(position.x + 50, position.y - 50)
		tween.tween_property(self, "position", Vector2(position.x + vector.x, position.y - vector.y), speed).set_ease(Tween.EASE_IN_OUT)
	else:
		$AnimatedBirdLeft.visible = true
		$AnimatedBirdLeft.play("left")
		tween.tween_property(self, "position", Vector2(position.x - vector.x, position.y - vector.y), speed).set_ease(Tween.EASE_IN_OUT)
	fly = true
	await tween.finished
	queue_free()
	pass # Replace with function body.