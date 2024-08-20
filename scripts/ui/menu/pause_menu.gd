extends Control
class_name PauseMenu

@onready var main = get_parent()
@onready var click_audio = $ClickAudio
@onready var skip_button = $MarginContainer/Items/Buttons/Skip

var levels_scene_path = "res://scenes/ui/level_select.tscn"

func exit_menu():
	main.exit_menu()

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
	SceneTransitionAutoLoad.change_scene_with_transition(levels_scene_path, false)


func _on_skip_pressed():
	main.exit_menu()
	LevelData.win()


func _on_fullscreen_button_pressed():
	GameManager.toggle_fullscreen()

func _process(delta):
	# SCOTCH !!
	print($"/root/SceneSelect")
	var levels_button = $MarginContainer/Items/Buttons/Levels
	if $"/root/SceneSelect":
		levels_scene_path = "res://scenes/ui/main.tscn"
		levels_button.text = "Title screen"
	else:
		levels_scene_path = "res://scenes/ui/level_select.tscn"
		levels_button.text = "Level selection"
		
