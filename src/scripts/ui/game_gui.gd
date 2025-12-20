extends CanvasLayer

# Le fullscreenbutton n'a l'air de servir a rien, mais bon jsp qui l'a mis la dc je le laisse.
@onready var pause_button = $Control/LevelActions/PauseButton
@onready var undo_button = $Control/LevelActions/UndoButton
@onready var retry_button = $Control/LevelActions/RetryButton
@onready var achievements_button = %AchievementsButton

@onready var level_actions = %LevelActions
@onready var level_select_side_actions = %LevelSelectSideActions
@onready var level_select_actions = %LevelSelectActions

var is_shown = true

func show_correct_game_gui():
	if get_tree().get_current_scene():
		var current_scene_name = get_tree().get_current_scene().get_name()
		var level_data = LevelData.get_current_level_data()
		# if current_scene_name == "WorldSelect" or current_scene_name == "YouWinLevel" or current_scene_name == "RedirectPageToOurGames":
		# j'enleve you win car c'est deg
		if current_scene_name == "WorldSelect" or current_scene_name == "RedirectPageToOurGames":
			PauseMenuAutoload.game_gui.show_level_select()
		elif current_scene_name == "Main":
			PauseMenuAutoload.game_gui.show_title_gui()
		else: 
			PauseMenuAutoload.game_gui.show_level_gui()
			if level_data and level_data.has("music"):
				MusicManager.set_music(level_data["music"])  # TODO; remettre la music
	else:
		PauseMenuAutoload.game_gui.show_title_gui()


# Called when the node enters the scene tree for the first time.
func _ready():
	show_title_gui()

	GameManager.on_win_animation.connect(_on_win_animation)

	achievements_button.visible = (GameManager.distribution_platform == GameManager.DistributionPlatform.PLAY_STORE || GameManager.distribution_platform == GameManager.DistributionPlatform.GAME_CENTER)

var disable_time_undo := 0.05
func _process(delta):
	var scene = get_tree().get_current_scene()
	if scene == null:
		return
	
	if (GameManager.is_on_win_animation) or (not scene is Level) or (scene is Level and len(scene.actions) == 0):
		undo_button.disabled = true
	else: 
		# for elt in get_tree().get_nodes_in_group("level_element"):
		# 	if elt is Block:
		# 		if elt.is_moving:
		# 			undo_button.disabled = true
		# 			disable_time_undo = 0.05
		# 			return 
		if !scene.can_undo():
			undo_button.disabled = true
			disable_time_undo = 0.05
		
		if disable_time_undo < 0.0:
			undo_button.disabled = false
		else:
			disable_time_undo -= delta
	
	var glove = %UndoButtonGlove
	if scene != null and scene is Level and glove.hidden:
		glove.set_visible(scene.num_globs_hidden > 0)
		glove.modulate = Color.TRANSPARENT
		var tween = glove.create_tween()
		tween.tween_property(glove, "modulate", Color.WHITE, 0.3)
		# tween.tween_property(self, "self_modulate:a", 0.0, 1.0)
		
		var anim_player: AnimationPlayer = %UndoButtonGlove.get_node("AnimationPlayer")
		if not anim_player.is_playing():
			anim_player.play("float")
		
	else:
		%UndoButtonGlove.set_visible(false)

func _input(event):
	if event.is_action_pressed("toggle_gui"):
		set_shown(not is_shown)

func set_shown(shown: bool):
	is_shown = shown
	if is_shown:
		show()
	else:
		hide()


func hide_gui():
	level_actions.hide()
	level_select_actions.hide()
	level_select_side_actions.hide()
	
	$WorldSelect.hide()

func show_level_select():
	level_actions.hide()
	level_select_actions.show()
	level_select_side_actions.show()
	
	$WorldSelect.show()

func show_title_gui():
	level_actions.hide()
	level_select_actions.hide()
	level_select_side_actions.hide()

	$WorldSelect.hide()

func show_level_gui():
	undo_button.disabled = false
	retry_button.disabled = false
	pause_button.disabled = false

	level_actions.show()
	level_select_actions.hide()
	level_select_side_actions.hide()
	
	$WorldSelect.hide()

func _on_win_animation():
	undo_button.disabled = true
	retry_button.disabled = true
	pause_button.disabled = true

func _on_pause_button_pressed():
	if PauseMenuAutoload.paused:
		PauseMenuAutoload.pause_menu.back()
	else:
		PauseMenuAutoload.pause_menu.pause()


func _on_retry_button_pressed():
	PauseMenuAutoload.pause_menu.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()

func _on_achievements_button_pressed():
	GameManager.open_achievements_menu()


func _on_level_select_options_button_pressed():
	PauseMenuAutoload.pause_menu.set_menu("OptionsMenu")


func _on_undo_button_pressed():
	var scene = get_tree().get_current_scene()
	if scene == null: 
		return
	if scene.can_undo():
		scene.undo_action()


func _on_info_button_pressed():
	PauseMenuAutoload.pause_menu.set_menu("AboutMenu")
	
