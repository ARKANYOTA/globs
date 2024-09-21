extends Control
class_name Menu

@onready var menu_manager: MenuManager = get_parent().get_parent()

func _on_back_button_pressed():
	menu_manager.back()
