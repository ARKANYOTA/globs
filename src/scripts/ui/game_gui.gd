extends CanvasLayer

@onready var main = get_node("/root/Main")

# Le fullscreenbutton n'a l'air de servir a rien, mais bon jsp qui l'a mis la dc je le laisse.

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_gui()

func show_level_select():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.show()
	$Control/LevelActions/RetryButton.hide()
	$Control/FullscreenButton.hide()

func hide_gui():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.hide()
	$Control/LevelActions/RetryButton.hide()
	$Control/FullscreenButton.hide()

func show_gui():
	$Control/LevelSelectPauseButton.hide()
	$Control/LevelActions/PauseButton.show()
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
