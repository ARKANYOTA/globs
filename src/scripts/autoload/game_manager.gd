extends Node

enum GamePlatform {
	WEB,
	MOBILE,
	PC,
	UNKNOWN,
	
	UNDEFINED,
}

const DISCORD_RPC_UPDATE_INTERVAL = 3.0
var discord_rich_presence: Node = null
var _discord_rpc_update_timer = 0.0

var game_platform: GamePlatform = GamePlatform.UNDEFINED:
	get:
		if game_platform == GamePlatform.UNDEFINED:
			match OS.get_name():
				"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
					game_platform = GamePlatform.PC
				"Android", "iOS":
					game_platform = GamePlatform.MOBILE
				"Web":
					game_platform = GamePlatform.WEB
				_:
					game_platform = GamePlatform.UNKNOWN
	
		return game_platform

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
	print("launched game")
	camera = global_camera_scene.instantiate()
	add_child(camera)
	
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(cursor_click, Input.CURSOR_IBEAM)

	_init_discord_rpc()

func _process(delta):
	if discord_rich_presence:
		_discord_rpc_update_timer -= delta
		if _discord_rpc_update_timer < 0:
			discord_rich_presence.update()
			_discord_rpc_update_timer = DISCORD_RPC_UPDATE_INTERVAL


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


func is_discord_rpc_supported() -> bool:
	match OS.get_name():
		"Windows", "macOS", "Linux":
			return GDExtensionManager.is_extension_loaded("res://addons/discord-rpc-gd/bin/discord-rpc-gd.gdextension")
		_:
			return false

func _init_discord_rpc():
	if not is_discord_rpc_supported():
		return
	
	var discord_rich_presence_scene: PackedScene = load("res://scenes/integration/discord_rich_presence.tscn")
	discord_rich_presence = discord_rich_presence_scene.instantiate()
	add_child(discord_rich_presence)
	
	discord_rich_presence.initialize()

func _update_discord_rpc():
	pass
	if not discord_rich_presence:
		return
	
	discord_rich_presence.update()



#caca proute de la par de corentin
