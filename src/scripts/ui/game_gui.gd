extends Control

@onready var main = get_node("/root/Main")

# Le fullscreenbutton n'a l'air de servir a rien, mais bon jsp qui l'a mis la dc je le laisse.

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_gui()

func show_level_select():
	$LevelSelectPauseButton.show()
	$PauseButton.hide()
	$RetryButton.hide()
	$FullscreenButton.hide()

func hide_gui():
	$LevelSelectPauseButton.hide()
	$PauseButton.hide()
	$RetryButton.hide()
	$FullscreenButton.hide()

func show_gui():
	$LevelSelectPauseButton.hide()
	$PauseButton.show()
	$RetryButton.show()
	$FullscreenButton.hide()


func _on_pause_button_pressed():
	if PauseMenuAutoload.paused:
		PauseMenuAutoload.pause_menu.back()
	else:
		PauseMenuAutoload.pause_menu.pause()


func _on_retry_button_pressed():
	PauseMenuAutoload.pause_menu.exit_menu()
	LevelData.reload_scene()
	GameManager.on_restart()
