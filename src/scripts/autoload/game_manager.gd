extends Node

enum GamePlatform {
	WEB,
	MOBILE,
	PC,
	UNKNOWN,

	UNDEFINED,
}

const discord_rpc_world_keys: Dictionary = {
	"1": {"name": "Globs City",    "large_image": "large_city"},
	"2": {"name": "Cheese Den",    "large_image": "large_cheese"},
	"3": {"name": "Chilly Tundra", "large_image": "large_snow"},
	"4": {"name": "Space Colony",  "large_image": "large_space"},
}
var update_discord_rpc_timer = 0.0

func _ready():
	camera = global_camera_scene.instantiate()
	add_child(camera)

	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	Input.set_custom_mouse_cursor(cursor)
	#Input.set_custom_mouse_cursor(cursor_click, Input.CURSOR_IBEAM)

	_init_discord_rpc()


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

func _process(delta):
	update_discord_rpc_timer -= delta
	if update_discord_rpc_timer < 0:
		_update_discord_rpc()
		update_discord_rpc_timer = 3.0

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


func _init_discord_rpc():
	DiscordRPC.app_id = 1282760428954325032 # Application ID
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"

	_update_discord_rpc()

func _update_discord_rpc():
	var level_data = LevelData.get_current_level_data()

	if level_data:
		print(level_data)
		
		DiscordRPC.details = "In level %s" % level_data["name"]

		if level_data.has("world"):
			var world = level_data["world"]
			if discord_rpc_world_keys.has(world):
				var key = discord_rpc_world_keys[world]
				DiscordRPC.large_image = key["large_image"]
				DiscordRPC.large_image_text = key["name"]

			else:
				# No world key was found, add it in discord_rpc_world_keys
				DiscordRPC.large_image = "icon_detailed"
				DiscordRPC.large_image_text = "In a level"
		
		else:
			# No world info defined in level data, add it in the corresponding level in LevelData
			DiscordRPC.large_image = "icon_detailed"
			DiscordRPC.large_image_text = "In a level"


	else:
		DiscordRPC.large_image = "icon_detailed"
		DiscordRPC.details = "In a menu"

	DiscordRPC.refresh()