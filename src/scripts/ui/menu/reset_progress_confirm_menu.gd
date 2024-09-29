extends Menu

func _on_yes_pressed():
	LevelData.completed_levels = []
	LevelData.worlds_finished = []
	LevelData.new_save_level_data()
	SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/world_select/world_select.tscn")

	menu_manager.exit_menu()

func _on_no_pressed():
	menu_manager.back()
