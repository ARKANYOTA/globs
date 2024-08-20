extends Button



func _on_pressed():
	$ClickAudio.play()
	if PauseMenuAutoload.paused:
		PauseMenuAutoload.pause_menu.back()
	else:
		PauseMenuAutoload.pause_menu.pause()

func _on_mouse_entered():
	$HoverAudio.play()
