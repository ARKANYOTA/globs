extends Control
class_name PauseMenu

@onready var main = get_parent()
@onready var click_audio = $ClickAudio
@onready var skip_button = $MarginContainer/Items/Buttons/Skip

func _on_resume_pressed():
	main.exit_menu()

func _on_restart_pressed():
	main.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()

func _on_quit_pressed():
	get_tree().quit()

func _on_levels_pressed():
	main.exit_menu()
	SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/level_select.tscn", false)


func _on_skip_pressed():
	main.exit_menu()
	LevelData.win()
