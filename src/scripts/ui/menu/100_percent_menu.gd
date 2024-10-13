extends Menu

func _on_continue_button_pressed():
	menu_manager.can_back = true
	if GameManager.achievement_manager:
		GameManager.achievement_manager.grant("ACH_COMPLETE_100_PERCENT")

	MusicManager.set_music("main_menu")
	SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/main.tscn", false)
	menu_manager.exit_menu()
