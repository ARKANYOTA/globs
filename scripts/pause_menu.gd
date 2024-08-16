extends Control
class_name PauseMenu

@onready var main = get_node("/root/Main")

func _on_resume_pressed():
	main.menu_manager.exit_menu()

func _on_quit_pressed():
	main.quit()

func _on_options_pressed():
	main.menu_manager.set_menu_by_name("OptionsMenu")
