extends Node

signal world_completed(world_id: String)

# for world select
var completed_levels: Array[String] = []
var selected_level_name: String = ""
var selected_world_index: int = 0
var worlds_finished: Array[int] = []
var disable_level_button: bool = false

var levels = [
	{ "name": "1-1", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_110.tscn"},
	{ "name": "1-2", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_120.tscn"},
	{ "name": "1-3", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_130.tscn"},
	{ "name": "1-4", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_132.tscn"},
	{ "name": "1-5", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_135.tscn"},
	{ "name": "1-6", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_137.tscn"},
	{ "name": "1-7", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_140.tscn"},
	{ "name": "1-8", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_150.tscn"},
	{ "name": "1-9", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_170.tscn"},
	{ "name": "1-10", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_180.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "1-⭐1", "world": "1", "music": "city", "scene": "res://scenes/levels_zoomed/world_1/level_160_hard.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "2-1", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_210.tscn"},
	{ "name": "2-2", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_213.tscn"},
	{ "name": "2-3", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_215.tscn"},
	{ "name": "2-4", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_220.tscn"},
	{ "name": "2-5", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_230.tscn"},
	{ "name": "2-6", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_240.tscn"},
	{ "name": "2-7", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_250.tscn"},
	{ "name": "2-8", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_260.tscn"},
	{ "name": "2-9", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_270.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "2-⭐1", "world": "2", "music": "cheese", "scene": "res://scenes/levels_zoomed/world_2/level_280.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "3-1", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_310.tscn"},
	{ "name": "3-2", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_325.tscn"},
	{ "name": "3-3", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_325_5.tscn"},
	{ "name": "3-4", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_326_other.tscn"},
	{ "name": "3-5", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_330.tscn"},
	{ "name": "3-6", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_350.tscn"},
	{ "name": "3-7", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_352.tscn"},
	{ "name": "3-8", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_355.tscn"},
	{ "name": "3-9", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_360.tscn"},
	{ "name": "3-10", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_380.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "3-⭐1", "world": "3", "music": "snow", "scene": "res://scenes/levels_zoomed/world_3/level_380_b.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "4-1", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_410.tscn"},
	{ "name": "4-2", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_411.tscn"},
	{ "name": "4-3", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_420.tscn"},
	{ "name": "4-4", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_422.tscn"},
	{ "name": "4-5", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_425.tscn"},
	{ "name": "4-6", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_426.tscn"},
	{ "name": "4-7", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_427.tscn"},
	{ "name": "4-8", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_500.tscn"},
	{ "name": "4-9", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_510.tscn"},

	{ "name": "Congrats!", "music": "main_menu", "scene": "res://scenes/levels_zoomed/you_win.tscn", "achievement": "ACH_COMPLETE_MAIN_GAME"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},

	{ "name": "4-⭐1", "world": "4", "music": "space", "scene": "res://scenes/levels_zoomed/world_4/level_430.tscn"},
	{ "name": "world selector", "music": "main_menu", "scene": "res://scenes/ui/world_select/world_select.tscn"},
]
var scene_to_level_data: Dictionary = _create_scene_to_level_data(levels)
var completion: Dictionary = _create_default_completion()

var current_level = -1
var level = 0

var test: Dictionary = {
	ConfigFile.new(): 2
}

func get_level_data(scene_path):
	if scene_to_level_data.has(scene_path):
		return scene_to_level_data[scene_path]
	return null

func get_current_level_data():
	return get_level_data(selected_level_name)


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
	pass

	#increment_level_and_change_scene()
	
func reload_scene() -> void:
	if SceneTransitionAutoLoad.scene_transition_instance.get_node("AnimationPlayer").is_playing():
		return
	BlockManagerAutoload.block_manager_instance.end_drag()
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path, false)

func increment_level_and_change_scene() -> void:
	BlockManagerAutoload.block_manager_instance.end_drag()
	increment_level()
	var scene_path = levels[current_level]["scene"]
	SceneTransitionAutoLoad.change_scene_with_transition(scene_path, true)


func save_level_data() -> void: # deprecated
	var config = ConfigFile.new()
	config.set_value("level_section","level", level)
	config.save("user://level_data.cfg")

func load_level_data() -> void:
	var config = ConfigFile.new()
	config.load("user://level_data.cfg")
	level = config.get_value("level_section","level", level)

func make_level_completed() -> void:
	if selected_level_name not in completed_levels:
		completed_levels.append(selected_level_name)
		new_save_level_data()

func new_save_level_data() -> void:
	var config = ConfigFile.new()
	config.set_value("levels", "completed_levels", completed_levels)
	config.save("user://level_data.cfg")

func new_load_level_data() -> void:
	var config = ConfigFile.new()
	config.load("user://level_data.cfg")
	completed_levels = config.get_value("levels", "completed_levels", completed_levels)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_load_level_data()	


func _input(event):
	if event.is_action_pressed("reload_button"):
		# SCOTCH
		var current_scene = get_tree().get_current_scene()
		if current_scene == null or current_scene.name in ["WorldSelect", "Main"]:
			return
		if GameManager.is_on_win_animation:
			return
		reload_scene()
	
	
	if event.is_action_pressed("removeme_debugtest_leo"):
		_load_level_completion()

func _process(delta: float) -> void:
	pass 

func _create_scene_to_level_data(levels_array: Array):
	var dict = {}
	for level_data in levels_array:
		var scene = level_data["scene"]
		if not dict.has(scene):
			dict[scene] = level_data
	
	return dict


func _create_default_completion():
	var dict = {}
	for level_data in levels:
		if level_data.has("world"):
			var world = level_data["world"]
			if dict.has(world):
				dict[world][1] += 1
			else:
				dict[world] = [0, 1]

	return dict


func _load_level_completion():
	for world in completion:
		var completion_item = completion[world]
		completion_item[0] = 0

	for level_path in completed_levels:
		var level_data: Variant = get_level_data(level_path)
		if level_data and level_data.has("world"):
			var world = level_data["world"]
			completion[world][0] += 1
		
	for world in completion:
		var completion_item = completion[world]
		if completion_item[0] == completion_item[1]:
			world_completed.emit(completion)
