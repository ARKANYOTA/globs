extends Menu
class_name PauseMenu

@onready var skip_button = %SkipButton

var levels_scene_path = "res://scenes/ui/world_select/world_select.tscn"

func _ready():
	if GameManager.game_platform != GameManager.GamePlatform.PC:
		%QuitButton.hide()

func exit_menu():
	menu_manager.exit_menu()

func _on_resume_button_pressed():
	menu_manager.exit_menu()
	PauseMenuAutoload.game_gui.show_correct_game_gui()

func _on_restart_button_pressed(): 
	menu_manager.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()

func _on_levels_button_pressed():
	SceneTransitionAutoLoad.change_scene_with_transition(levels_scene_path, false)
	menu_manager.exit_menu()

func _on_quit_button_pressed():
	menu_manager.set_menu("QuitConfirmMenu")

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
	var level_data: Variant = LevelData.get_current_level_data()
	if level_name_label:
		if level_data:
			level_name_label.text = level_data["name"]
		else:
			level_name_label.text = ""

	# Change buttons if on title screen	
	var is_on_level_select = (current_scene.name == "YouWinLevel" or current_scene.name == "WorldSelect")
	%SkipButton.disabled = is_on_level_select
	if is_on_level_select:
		levels_scene_path = "res://scenes/main.tscn"
		levels_button.text = "MENU_TITLE_SCREEN"
		%RestartButton.hide()
		%Title.text = "MENU_MENU"
	else:
		levels_scene_path = "res://scenes/ui/world_select/world_select.tscn"
		levels_button.text = "MENU_LEVELS"
		%RestartButton.show()
		%Title.text = "MENU_PAUSED"
	


func _on_skip_button_removeme_pressed():
	menu_manager.exit_menu()
	LevelData.win()



func _on_debug_is_auth_pressed():
	if GameManager.google_play_interface:
		GameManager.google_play_interface.popup_is_authenticated()

func _update_debug_text():
	var debug_text = %DebugText
	debug_text.text = """
	""".format({

	})