extends Node

# var levels = [
# 	{ "name": "1-1", "music": "city", "scene": "res://scenes/levels/world_1/level_110_intro.tscn"},
# 	{ "name": "1-2", "music": "city", "scene": "res://scenes/levels/world_1/level_120_push.tscn"},
# 	{ "name": "1-3", "music": "city", "scene": "res://scenes/levels/world_1/level_130_support.tscn"},
# 	{ "name": "1-4", "music": "city", "scene": "res://scenes/levels/world_1/level_140_only_red_wins.tscn"},
# 	{ "name": "1-5", "music": "city", "scene": "res://scenes/levels/world_1/level_150.tscn"},
# 	{ "name": "1-6", "music": "city", "scene": "res://scenes/levels/world_1/level_160.tscn"},
	
# 	{ "name": "2-1", "music": "cheese", "scene": "res://scenes/levels/world_2/level_210.tscn"},
# 	{ "name": "2-2", "music": "cheese", "scene": "res://scenes/levels/world_2/level_220_beta.tscn"},
# 	{ "name": "2-3", "music": "cheese", "scene": "res://scenes/levels/world_2/level_230.tscn"},
# 	{ "name": "2-4", "music": "cheese", "scene": "res://scenes/levels/world_2/level_235.tscn"},
# 	#{ "name": "2-4", "music": "cheese", "scene": "res://scenes/levels/world_2/level_240.tscn"},
# 	{ "name": "2-5", "music": "cheese", "scene": "res://scenes/levels/world_2/level_250.tscn"},
# 	#{ "name": "2-6", "music": "cheese", "scene": "res://scenes/levels/world_2/level_255.tscn"},
# 	{ "name": "2-6", "music": "cheese", "scene": "res://scenes/levels/world_2/level_260.tscn"},
# 	{ "name": "2-7", "music": "cheese", "scene": "res://scenes/levels/world_2/level_270.tscn"},
	
# 	{ "name": "3-1", "music": "snow", "scene": "res://scenes/levels/world_3/level_310.tscn"},
# 	{ "name": "3-2", "music": "snow", "scene": "res://scenes/levels/world_3/level_320.tscn"},
# 	{ "name": "3-3", "music": "snow", "scene": "res://scenes/levels/world_3/level_330_rework.tscn"},
# 	{ "name": "3-4", "music": "snow", "scene": "res://scenes/levels/world_3/level_340_rework.tscn"},
# 	{ "name": "3-5", "music": "snow", "scene": "res://scenes/levels/world_3/level_350.tscn"},
# 	#{ "name": "3-6", "music": "snow", "scene": "res://scenes/levels/world_3/level_360.tscn"},
# 	{ "name": "3-6", "music": "snow", "scene": "res://scenes/levels/world_3/level_370.tscn"},
# 	{ "name": "3-7", "music": "snow", "scene": "res://scenes/levels/world_3/level_380.tscn"},
	
# 	{ "name": "4-1", "music": "snow", "scene": "res://scenes/levels/world_4/level_410.tscn"},
# 	{ "name": "4-2", "music": "snow", "scene": "res://scenes/levels/world_4/level_420.tscn"},
# 	{ "name": "4-3", "music": "snow", "scene": "res://scenes/levels/world_4/level_420_guigui.tscn"},
# 	{ "name": "4-4", "music": "snow", "scene": "res://scenes/levels/world_4/level_430_guigui.tscn"},
# 	{ "name": "4-5", "music": "snow", "scene": "res://scenes/levels/world_4/level_440.tscn"},
# 	{ "name": "4-6", "music": "snow", "scene": "res://scenes/levels/world_4/level_490_guigui.tscn"},
# 	{ "name": "4-7", "music": "snow", "scene": "res://scenes/levels/world_4/level_500_guigui.tscn"},
# 	{ "name": "You Win", "music": "city", "scene": "res://scenes/levels/you_win.tscn"},
# ]

var levels = [
	{ "name": "1-1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_110.tscn"},
	{ "name": "1-2", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_120.tscn"},
	{ "name": "1-3", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_130.tscn"},
	{ "name": "1-4", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_140.tscn"},
	{ "name": "1-5", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_150.tscn"},
	{ "name": "1-6", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_160.tscn"},

	{ "name": "2-1", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_210.tscn"},
	{ "name": "2-2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_220.tscn"},
	{ "name": "2-3", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_230.tscn"},
	{ "name": "2-4", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_240.tscn"},
	{ "name": "2-5", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_250.tscn"},
	{ "name": "2-6", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_260.tscn"},
	{ "name": "2-7", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_270.tscn"},

	{ "name": "3-1", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_310.tscn"},
	{ "name": "3-2", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_320.tscn"},
	{ "name": "3-3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_330.tscn"},
	{ "name": "3-5", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_350.tscn"},
	{ "name": "3-6", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_370.tscn"},

	{ "name": "4-1", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_410.tscn"},
	{ "name": "4-2", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_420.tscn"},
	{ "name": "4-3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_430.tscn"},
	{ "name": "4-4", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_440.tscn"},
	{ "name": "4-5", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_490.tscn"},
	{ "name": "4-6", "music": "snow", "scene": "res://scenes/levels_zoomed/world_4/level_500.tscn"},

	{ "name": "You Win", "music": "city", "scene": "res://scenes/levels/you_win.tscn"},
]

var names = [
	"Introduction 1-1",
	"1-2",
	"1-3",
	"1-4",
	"2-1",
	"2-2",
	"2-3",
	"2-4",
	"2-5",
]
var current_level = -1
var level = 0

func get_current_level_data():
	if current_level < 0 or current_level >= levels.size():
		return null 
	return levels[current_level]

func increment_level() -> void:
	if level == current_level:
		level += 1
	current_level += 1
	if level >= len(levels):
		level = len(levels)-1
	if current_level >= len(levels):
		current_level = len(levels)-1
	save_level_data()

func win() -> void:
	increment_level_and_change_scene()
	
func reload_scene() -> void:
	BlockManagerAutoload.block_manager_instance.end_drag()
	# var scene_path = levels[level]["scene"]
	#get the current scene path
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path, false)

func increment_level_and_change_scene() -> void:
	BlockManagerAutoload.block_manager_instance.end_drag()
	increment_level()
	var scene_path = levels[current_level]["scene"]
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path, true)


func save_level_data() -> void:
	var config = ConfigFile.new()
	config.set_value("level_section","level", level)
	config.save("user://level_data.cfg")

func load_level_data() -> void:
	var config = ConfigFile.new()
	config.load("user://level_data.cfg")
	level = config.get_value("level_section","level", level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_data()
	var volume_config = ConfigFile.new()
	volume_config.load("user://volume.cfg")
	var master_value = volume_config.get_value("Sound", "Master", 1)
	var music_value = volume_config.get_value("Sound", "Music", 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_value))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("removeme2_nolan_usge_to_change_scene"):
		win()
	
	if event.is_action_pressed("reload_button"):
		reload_scene()
