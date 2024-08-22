extends AnimatedSprite2D

var value = 0.0
var start_pos = Vector2.ZERO

@export var game_logo_range = 4

func _ready():
	play()
	start_pos = Vector2(position)

func _process(delta):
	value += delta
	
	position = start_pos + Vector2(0, sin(value) * game_logo_range)
