extends Node

var levels = [
	{ "name": "1-1", "scene": "res://scenes/levels/level_100_intro.tscn"},
	{ "name": "1-2", "scene": "res://scenes/levels/level_110_push.tscn"},
	{ "name": "1-3", "scene": "res://scenes/levels/level_120_support.tscn"},
	{ "name": "1-4", "scene": "res://scenes/levels/level_140_only_red_wins.tscn"},

	{ "name": "2-1", "scene": "res://scenes/levels/world_2/level_10_0.tscn"},
	{ "name": "2-2", "scene": "res://scenes/levels/world_2/level_11_beta.tscn"},
	{ "name": "2-3", "scene": "res://scenes/levels/world_2/level_12.tscn"},
	{ "name": "2-4", "scene": "res://scenes/levels/world_2/level_13.tscn"},
	{ "name": "2-5", "scene": "res://scenes/levels/world_2/level_14.tscn"},
	{ "name": "2-6", "scene": "res://scenes/levels/world_2/level_14_bis.tscn"},
	{ "name": "2-7", "scene": "res://scenes/levels/world_2/level_15.tscn"},

	{ "name": "3-1", "scene": "res://scenes/levels/world_3/level_0.tscn"},
	# { "name": "3-2", "scene": "res://scenes/levels/world_3/level_0_1.tscn"},
	{ "name": "3-2", "scene": "res://scenes/levels/world_3/level_1.tscn"},
	{ "name": "3-3", "scene": "res://scenes/levels/world_3/level_3.tscn"},
	{ "name": "3-4", "scene": "res://scenes/levels/world_3/level_4.tscn"},
	{ "name": "You Win", "scene": "res://scenes/levels/you_win.tscn"},
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
var current_level = 0
var level = 0

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
	var scene_path = levels[level]["scene"]
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
	var volume_config = ConfigFile.new()
	volume_config.load("user://volume.cfg")
	var master_value = volume_config.get_value("volume", "Master", 1)
	var music_value = volume_config.get_value("volume", "Music", 1)
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
