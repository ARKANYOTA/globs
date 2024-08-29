extends Camera2D
class_name GlobalCamera

var play_dimensions := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

func _ready():
	pass 

func _process(delta):
	update_dimensions()
	

func update_dimensions():
	position = play_dimensions/2
