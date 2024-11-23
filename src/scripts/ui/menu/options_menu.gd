extends Menu

func _on_reset_progress_pressed():
	menu_manager.set_menu("ResetProgressConfirmMenu")


func _on_back_button_pressed():
	menu_manager.back()


func _on_language_pressed():
	TranslationServer.set_locale("xx")
