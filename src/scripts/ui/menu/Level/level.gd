@tool
extends Node2D
class_name LevelNew

enum LevelButtonStyle {
	NORMAL, STAR
}
enum LevelState {
	LOCKED,
	UNLOCKED,
	COMPLETED
}

const themes = {
	LevelButtonStyle.NORMAL: {
		LevelState.LOCKED: preload("res://assets/images/ui/level_button_locked.png"),
		LevelState.UNLOCKED: preload("res://assets/images/ui/level_button_unlocked.png"),
		LevelState.COMPLETED: preload("res://assets/images/ui/level_button_completed.png"),
	}, 
	LevelButtonStyle.STAR: {
		LevelState.LOCKED: preload("res://assets/images/ui/level_button_locked_star.png"),
		LevelState.UNLOCKED: preload("res://assets/images/ui/level_button_unlocked_star.png"),
		LevelState.COMPLETED: preload("res://assets/images/ui/level_button_completed_star.png"),
	},
}

@export var levels_unlock : Array[LevelNew]
@export_file("*.tscn") var levelScene : String = ""
@export var state : LevelState = LevelState.LOCKED
@export var world_unlock_id : int = 0
@export var button_style: LevelButtonStyle = LevelButtonStyle.NORMAL:
	set(value):
		button_style = value
		change_icon()

var levels_required : Array[LevelNew] = []
var pathScene : PackedScene = preload("res://scenes/ui/world_select/path_2d.tscn")
var path_instances : Array[Path2D]
var unlocked_paths : Array[Path2D]
var is_unlocked : bool = false
var disable_button = false
var can_add = false
var added_required = false


###################### DOT ######################
var dots : Array[PathFollow2D] = []
var dot_gap = 8#5
var dot_speed = 13

var changed = false
var dot_done = false
var world : World
func _ready():
	if Engine.is_editor_hint():
		return
	
	world = get_parent()

	create_path_to_level_unlock()
		
	if levels_unlock != null:
		for level in levels_unlock:
			if level == null:
				continue
			if level not in level.levels_required:
				level.levels_required.append(self)

	if levelScene in LevelData.completed_levels:
		state = LevelState.COMPLETED
		handle_world_unlock()
	
	change_icon()

func create_path_to_level_unlock():
	for level_unlock in levels_unlock:
		if level_unlock == null:
			continue
		create_path(level_unlock)

func create_path(level_unlock: LevelNew):
	var path = pathScene.instantiate()
	path_instances.append(path)
	path.curve = Curve2D.new()
	path.curve.add_point(Vector2(0,0))
	path.z_index = -1
	path.curve.add_point(level_unlock.position - position)
	add_child(path)
	var distance = level_unlock.position.distance_to(position)
	var number_dot = distance / dot_gap
	add_dot(number_dot, path, level_unlock.position - position)

func handle_world_unlock():
	if world_unlock_id != 0:
			if world_unlock_id not in LevelData.worlds_finished:
				LevelData.worlds_finished.append(world_unlock_id)
				var next_world = LevelData.selected_world_index + 1
				if next_world >= world_unlock_id:
					LevelData.selected_world_index = next_world

func check_unlock():
	var all_unlocked = true
	for level in levels_required:
		if level.state != LevelState.COMPLETED:
			all_unlocked = false

	if all_unlocked and state == LevelState.LOCKED and (world.world_index == 0 or world.world_index in LevelData.worlds_finished):
		state = LevelState.UNLOCKED
	
func get_theme():
	if themes.has(button_style):
		return themes[button_style]
	return themes[LevelButtonStyle.NORMAL]

func change_icon():
	var theme = get_theme()
	$Button.icon = theme[state]

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	check_unlock()
	change_icon()
			
	# if state != LevelState.LOCKED:
	for path in path_instances:
		for dot in dots:
			dot.progress += (delta * dot_speed) / levels_unlock.size()
	pass
var musics : Array[String] = ["city", "cheese", "snow", "snow"]

func add_dot(number: int, path: Path2D, vector: Vector2):
	var path_follow = path.get_node("PathFollow2D")
	for i in range(number):
		var float_i = float(i)
		var float_number = float(number)
		var float_ratio = float_i/float_number
		var path_follow_instance : PathFollow2D = path_follow.duplicate()
		path_follow_instance.progress = vector.length() * float_ratio
		path_follow_instance.visible = true 
		path.add_child(path_follow_instance)
		dots.append(path_follow_instance)

func start_level():
	
	if state == LevelState.LOCKED:
		return
	# MusicManager.set_music(world.world_music)
	LevelData.selected_level_name = levelScene
	SceneTransitionAutoLoad.change_scene_with_transition(levelScene)

func _on_button_pressed() -> void:
	if Engine.is_editor_hint():
		return
	if LevelData.disable_level_button:
		return
	start_level()
	pass # Replace with function body.
