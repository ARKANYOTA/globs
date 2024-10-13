extends Node

var retry_area_count: int = 0
var achivement_area_retry = 5
var game_manager : GameManager

var moved_bird_level = {
	"res://scenes/levels_zoomed/world_1/level_110.tscn": false, 
	"res://scenes/levels_zoomed/world_1/level_120.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_130.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_135.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_150.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_170.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_180.tscn": false,
	"res://scenes/levels_zoomed/world_1/level_160_hard.tscn": false,
}

var config = ConfigFile.new()

func _ready():
	config.load("user://achivement_data.cfg")

	var moved_bird_level_config = config.get_value("bird", "moved_bird_level", moved_bird_level)
	if not moved_bird_level_config == null:
		moved_bird_level = moved_bird_level_config
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increment_retry_area_count() -> void:
	retry_area_count += 1
	if retry_area_count == achivement_area_retry:
		if GameManager.achievement_manager:
			GameManager.achievement_manager.grant("ACH_GLOBS_IN_VOID_5_TIMES")


func no_bird_moved(current_tree: SceneTree) -> void:
	var current_scene = current_tree.current_scene
	var scene_file_path = current_scene.scene_file_path

	if not moved_bird_level.has(scene_file_path):
		return
	var birds_node = current_tree.get_nodes_in_group("birds")

	if birds_node == null:
		return

	for node in birds_node:
		if not node.fly:
			return

	if moved_bird_level.has(scene_file_path):
		moved_bird_level[scene_file_path] = true

	config.set_value("bird", "moved_bird_level", moved_bird_level)
	var err = config.save("user://achivement_data.cfg")
	if err:
		print("Error in save achivement_data config")
	for value in moved_bird_level.values():
		if not value:
			return
		
	if GameManager.achievement_manager == null:
		return
	GameManager.achievement_manager.grant("ACH_SCARECROW")
