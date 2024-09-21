extends Menu
class_name PauseMenu

@onready var skip_button = %SkipButton

var levels_scene_path = "res://scenes/ui/world_select/world_select.tscn"

func _ready():
	pass
	# if GameManager.game_platform != GameManager.GamePlatform.PC:
	# 	%FullscreenButton.hide()

func exit_menu():
	menu_manager.exit_menu()

func _on_resume_button_pressed():
	menu_manager.exit_menu()
	PauseMenuAutoload.game_gui.show_correct_game_gui()

func _on_restart_button_pressed(): 
	menu_manager.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()

func _on_quit_pressed():
	get_tree().quit()

func _on_levels_button_pressed():
	SceneTransitionAutoLoad.change_scene_with_transition(levels_scene_path, false)
	menu_manager.exit_menu()


func _on_options_button_pressed():
	menu_manager.set_menu("OptionsMenu")

func _on_skip_pressed():
	menu_manager.exit_menu()
	LevelData.win()


func _on_fullscreen_button_pressed():
	GameManager.toggle_fullscreen()

func _process(delta):
	# SCOTCH !!
	var levels_button = %LevelsButton
	var current_scene = get_tree().get_current_scene()
	if not current_scene:
		return
	
	# Change level name
	var level_name_label = %LevelName
	var level_data = LevelData.get_current_level_data()
	if level_name_label:
		if level_data:
			level_name_label.text = level_data["name"]
		else:
			level_name_label.text = ""

	# Change buttons if on title screen	
	var is_on_level_select = (current_scene.name == "YouWinLevel" or current_scene.name == "WorldSelect")
	%SkipButton.disabled = is_on_level_select
	if is_on_level_select:
		levels_scene_path = "res://scenes/menu_manager.tscn"
		levels_button.text = "Title screen"
	else:
		levels_scene_path = "res://scenes/ui/world_select/world_select.tscn"
		levels_button.text = "Levels"
	
