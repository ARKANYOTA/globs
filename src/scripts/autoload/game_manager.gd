extends Node

const GAME_VERSION = "1.1"

var cursor = preload("res://assets/images/ui/cursor_big.png")
var cursor_click = preload("res://assets/images/ui/cursor_click_big.png")
var global_camera_scene: PackedScene = preload("res://scenes/camera/global_camera.tscn")

var camera: Camera2D
var is_fullscreen := false

func win():
	#check if level in level data
	var level_in_data = false
	var next_level_name = "res://scenes/ui/world_select/world_select.tscn"
	var next_sound = "city"
	for i in range(LevelData.levels.size()):
		if LevelData.levels[i]["scene"] == get_tree().current_scene.scene_file_path:
			#check if level is not the last level
			level_in_data = true
			if i + 1 < LevelData.levels.size():
				next_level_name = LevelData.levels[i + 1]["scene"]
				next_sound = LevelData.levels[i + 1]["music"]
	LevelData.make_level_completed()
	LevelData.selected_level_name = next_level_name
	MusicManager.set_music(next_sound)
	SceneTransitionAutoLoad.change_scene_with_transition(next_level_name, true)


func _ready():
	camera = global_camera_scene.instantiate()
	add_child(camera)

	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(cursor_click, Input.CURSOR_IBEAM)

func _process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("left_click"):
		Input.set_custom_mouse_cursor(cursor_click)
	
	if event.is_action_released("left_click"):
		Input.set_custom_mouse_cursor(cursor)
	
	if event.is_action_pressed("undo_action"):
		var scene = get_tree().get_current_scene()
		if scene == null:
			return
		
		if scene is Level:
			scene.undo_action()

func on_restart():
	pass

func before_scene_change():
	BlockManagerAutoload.blocks.clear()
	BlockManagerAutoload.reset()

func toggle_fullscreen():
	is_fullscreen = not is_fullscreen
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED)
