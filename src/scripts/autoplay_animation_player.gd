extends AnimationPlayer

@export var default_animation: String 

# Called when the node enters the scene tree for the first time.
func _ready():
	play(default_animation)
