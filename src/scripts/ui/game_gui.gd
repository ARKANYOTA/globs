extends CanvasLayer

@onready var main = get_node_or_null("/root/Main")

# Le fullscreenbutton n'a l'air de servir a rien, mais bon jsp qui l'a mis la dc je le laisse.

func show_correct_game_gui():
	if get_tree().get_current_scene():
		var current_scene_name = get_tree().get_current_scene().get_name()
		 # var level_data = LevelData.get_current_level_data()
		if current_scene_name == "WorldSelect" or current_scene_name == "YouWinLevel":
			PauseMenuAutoload.game_gui.show_level_select()
		elif current_scene_name == "Main" or current_scene_name == "RedirectPageToOurGames":
			PauseMenuAutoload.game_gui.hide_gui()
		else: 
			PauseMenuAutoload.game_gui.show_gui()
			# MusicManager.set_music(level_data["music"])  # TODO; remettre la music
	else:
		PauseMenuAutoload.game_gui.hide_gui()


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_gui()
	
func _process(_delta):
	var scene = get_tree().get_current_scene()
	if scene == null:
		return
	
	if (not scene is Level) or (scene is Level and len(scene.actions) == 0):
		$Control/LevelActions/UndoButton.disabled = true
	else: 
		$Control/LevelActions/UndoButton.disabled = false

func show_level_select():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.show()
	$Control/LevelActions/UndoButton.hide()
	$Control/LevelActions/RetryButton.hide()
	$Control/FullscreenButton.hide()

func hide_gui():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.hide()
	$Control/LevelActions/UndoButton.hide()
	$Control/LevelActions/RetryButton.hide()
	$Control/FullscreenButton.hide()

func show_gui():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.show()
	$Control/LevelActions/UndoButton.show()
	$Control/LevelActions/RetryButton.show()
	$Control/FullscreenButton.hide()


func _on_pause_button_pressed():
	if PauseMenuAutoload.paused:
		PauseMenuAutoload.pause_menu.back()
	else:
		PauseMenuAutoload.pause_menu.pause()


func _on_retry_button_pressed():
	PauseMenuAutoload.pause_menu.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()


func _on_ui_icon_button_pressed():
	var scene = get_tree().get_current_scene()
	if scene == null: 
		return
	
	if scene is Level:
		scene.undo_action()
