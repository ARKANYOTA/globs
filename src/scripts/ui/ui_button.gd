extends Button
class_name UIButton

func _on_pressed():
	$ClickAudio.play()

func _on_mouse_entered():
	$HoverAudio.play()

