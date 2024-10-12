extends Button
class_name UIButton

var is_hover_enabled = true

func _ready():
	if GameManager.game_platform == GameManager.GamePlatform.MOBILE:
		is_hover_enabled = false
		add_theme_stylebox_override("hover", get_theme_stylebox("normal"))

func _on_pressed():
	$ClickAudio.play()

func _on_mouse_entered():
	if is_hover_enabled:
		$HoverAudio.play()
