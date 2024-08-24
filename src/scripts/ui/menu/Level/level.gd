extends Node2D
class_name LevelNew

var levels_required : Array[LevelNew] = []
@export var levels_unlock : Array[LevelNew]
var pathScene : PackedScene = preload("res://scenes/ui/world_select/path_2d.tscn")
@export var levelScene : String = ""
var path_instances : Array[Path2D]
var unlocked_paths : Array[Path2D]
var is_unlocked : bool = false
@export var state : LevelState = LevelState.LOCKED
var dots : Array[PathFollow2D] = []

var can_add = false
var added_required = false

enum LevelState {
	LOCKED,
	UNLOCKED,
	COMPLETED
}
var changed = false
var dot_done = false

func _ready():
	#check if the level is unlocked
	for level_unlock in levels_unlock:
		if level_unlock == null:
			continue
		var path = pathScene.instantiate()
		path_instances.append(path)
		# if level_unlock.state != LevelState.LOCKED:
		# 	unlocked_paths.append(path)
		path.curve = Curve2D.new()
		path.curve.add_point(Vector2(0,0))
		path.z_index = -1
		path.curve.add_point(level_unlock.position - position)
		add_child(path)
		add_dot(5, path, level_unlock.position - position)
	if levels_unlock != null:
		for level in levels_unlock:
			if level != null and level not in level.levels_required:
				level.levels_required.append(self)
	if levelScene in LevelData.completed_levels:
		state = LevelState.COMPLETED
	pass

func check_unlock():
	var all_unlocked = true
	for level in levels_required:
		if level.state != LevelState.COMPLETED:
			all_unlocked = false
	if all_unlocked and state == LevelState.LOCKED:
		state = LevelState.UNLOCKED
	

func change_icon():
	if state == LevelState.LOCKED:
		$Button.icon = preload("res://assets/images/ui/locked_button.png")
	elif state == LevelState.UNLOCKED:
		$Button.icon = preload("res://assets/images/ui/button_clicked.png")
	elif state == LevelState.COMPLETED:
		$Button.icon = preload("res://assets/images/ui/button.png")
		

func _process(delta: float) -> void:
	check_unlock()
	change_icon()
			
	if state != LevelState.LOCKED:
		for path in path_instances:
			for dot in dots:
				dot.progress += delta * 20
	pass


func add_dot(number: int, path: Path2D, vector: Vector2):
	#dupolicate pathfopllow2d and add it to the path
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
	LevelData.selected_level_name = levelScene
	SceneTransitionAutoLoad.change_scene_with_transition(levelScene)

# func add_dot_timer(number: int, path: Path2D, vector: Vector2):
# 	for i in range(number):
# 		var timer = Timer.new()
# 		timer.one_shot = true
# 		add_child(timer)
# 		timer.set_wait_time(1 * i)
# 		var callback = func() -> void:
# 			add_single_dot(i, number, path, vector)
# 		timer.timeout.connect(callback)
# 		timer.start()


# func add_single_dot(i, number, path, vector):
# 		print("add single dot")
# 		var path_follow = path.get_node("PathFollow2D")
# 		var float_i = float(i)
# 		var float_number = float(number)
# 		var float_ratio = float_i/float_number
# 		var path_follow_instance : PathFollow2D = path_follow.duplicate()
# 		path_follow_instance.visible = true 
# 		path_follow_instance.progress = vector.length() * float_ratio
# 		path.add_child(path_follow_instance)
# 		dots.append(path_follow_instance)


func _on_button_pressed() -> void:
	start_level()
	pass # Replace with function body.
