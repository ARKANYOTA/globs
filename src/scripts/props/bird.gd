extends Node2D

var fly = false
var vector = Vector2(400,+300)
var speed = 4
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
	#get mouse position
	fly_bird()
	pass # Replace with function body.


func fly_bird():
	var mouse_position = get_viewport().get_mouse_position()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	if fly:
		return
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
	pass # Replace with function body.