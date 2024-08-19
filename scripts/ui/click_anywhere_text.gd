extends Label

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if fmod(time, 1.0) < 0.5:
		label_settings.font_color = Color.WHITE
	else:
		label_settings.font_color = Color(0.5, 0.5, 0.5)
