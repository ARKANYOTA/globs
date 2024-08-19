extends Sprite2D

var value = 0.0
var start_pos = Vector2.ZERO

func _ready():
	start_pos = Vector2(position)

func _process(delta):
	value += delta
	
	position = start_pos + Vector2(0, sin(value) * 8)
