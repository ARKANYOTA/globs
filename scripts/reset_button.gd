extends Node2D

func _on_ui_button_pressed():
    LevelData.current_level = 0
    LevelData.level = 0
    LevelData.save_level_data()
    LevelData.reload_scene()
