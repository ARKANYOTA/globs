extends Control
class_name OptionsMenu

@onready var main = get_node("/root/Main")

func _on_back_pressed():
	main.menu_manager.back()
