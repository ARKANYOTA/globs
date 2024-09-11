extends Label

@export var color_1: Color = Color.WHITE
@export var color_2: Color = Color(0.7, 0.7, 0.7)

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if fmod(time, 1.0) < 0.5:
		label_settings.font_color = color_1
	else:
		label_settings.font_color = color_2
