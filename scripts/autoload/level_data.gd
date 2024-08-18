extends Node

var levels = [
	{ "name": "1-1", "scene": "res://scenes/levels/level_100_intro.tscn"},
	{ "name": "1-1", "scene": "res://scenes/levels/level_110_push.tscn"},
	{ "name": "1-1", "scene": "res://scenes/levels/level_120_support.tscn"},
	{ "name": "1-1", "scene": "res://scenes/levels/level_140_only_red_wins.tscn"},

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
	
	# { "name": "Gumi & Rodo", "scene": "res://scenes/levels/world_2/level_10_0.tscn"},
	# { "name": "Rise together", "scene": "res://scenes/levels/world_2/level_11_beta.tscn"},
	# { "name": "To the star", "scene": "res://scenes/levels/world_2/level_12.tscn"},
	# { "name": "Return the favor", "scene": "res://scenes/levels/world_2/level_13.tscn"},
	# { "name": "Soft landing", "scene": "res://scenes/levels/world_2/level_13.tscn"},

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

var level = 0

func increment_level() -> void:
	level += 1
	if level >= len(levels):
		level = len(levels)
	save_level_data()

func increment_level_and_change_scene() -> void:
	BlockManagerAutoload.block_manager_instance.end_drag()
	increment_level()
	var scene_path = levels[level]["scene"]
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path)

func reload_scene() -> void:
	BlockManagerAutoload.block_manager_instance.end_drag()
	var scene_path = levels[level]["scene"]
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path)

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("removeme2_nolan_usge_to_change_scene"):
		increment_level_and_change_scene()
	
	if event.is_action_pressed("reload_button"):
		reload_scene()
