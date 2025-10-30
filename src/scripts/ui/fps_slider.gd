extends HSlider
#mostly copied from volume slider

@export var slide_name := "FPS limit: "
@onready var label = $"../Label"

var client_hz = DisplayServer.screen_get_refresh_rate()
var fps_limit_value: int

func _ready():
	max_value = client_hz * 2
	value = client_hz
	label.text = slide_name + str(int(client_hz))

func _on_value_changed(value):
	fps_limit_value = value
		
	if fps_limit_value == 0:
		label.text = slide_name + "∞"
	else:
		label.text = slide_name + str(fps_limit_value)

func _on_drag_started():
	Engine.max_fps = client_hz

func _on_drag_ended(value_changed):
	Engine.max_fps = fps_limit_value
