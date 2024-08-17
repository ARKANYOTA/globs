extends Control
class_name PauseMenu

@onready var main = get_parent()
func _on_resume_pressed():
	main.exit_menu()

func _on_quit_pressed():
	get_tree().quit()
	

func _on_options_pressed():
	main.set_menu_by_name("OptionsMenu")
