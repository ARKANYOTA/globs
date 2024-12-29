extends Menu

func _ready():
	_update_language_button()

func _on_reset_progress_pressed():
	menu_manager.set_menu("ResetProgressConfirmMenu")

func _on_back_button_pressed():
	menu_manager.back()


func _on_language_pressed():
	GameManager.next_locale()
	_update_language_button()

func _update_language_button():
	%Language.text = (tr("MENU_OPTIONS_LANGUAGE") + " · " + tr("LANGUAGE_NAME"))
