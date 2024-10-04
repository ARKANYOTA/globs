extends Sprite2D

@export var amplitude = 2.0
@export var frequency = 1.0

var t = 0.0
var float_y = 0.0

func _ready():
	pass


func _process(delta):
	t = fmod(t + delta, TAU)
	float_y = sin()
