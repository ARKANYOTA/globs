extends Control
class_name PauseMenu

@onready var main = get_node("/root/Main")

func _on_resume_pressed():
	main.unpause()


func _on_quit_pressed():
	main.quit()
