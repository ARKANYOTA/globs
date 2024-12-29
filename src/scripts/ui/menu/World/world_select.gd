@tool
extends Node2D
class_name WorldSelect

@onready var world_select_gui = PauseMenuAutoload.game_gui.get_node("WorldSelect")

var world_separator_scene = preload("res://scenes/ui/world_select/world_separator.tscn")

@export var world: Array[ PackedScene]
@export var scroll: ScrollComponent
var node_worlds : Array[Node2D]
var world_index = 0
var is_timing = false
var left_button: Button
var right_button: Button

var icon_on = "res://assets/images/ui/world_index_dot_on.png"
var icon_off = "res://assets/images/ui/world_index_dot.png"
var texture_on : Texture2D = load(icon_on)
var texture_off : Texture2D = load(icon_off)

func _ready():
	var dot_container = world_select_gui.get_node("MarginContainer/CenterContainer/DotContainer")
	if dot_container != null:
		for child in dot_container.get_children():
			child.queue_free()

	if world.size() == 0:
		return
	for i in range(0, world.size()):
		var node_world = world[i].instantiate()
		node_world.set_position(Vector2(i * 16*15, 0))


		var w = ProjectSettings.get_setting("display/window/size/viewport_width")
		var h = ProjectSettings.get_setting("display/window/size/viewport_height")
		_add_world_separator(node_world, Vector2(0, h/2))
		if i == world.size() - 1:
			_add_world_separator(node_world, Vector2(w, h/2))
			
		node_worlds.append(node_world)
		scroll.add_child(node_world)

		
	add_dot()
	update_dot()
	world_index = LevelData.selected_world_index
	LevelData.selected_level_name = ""
	MusicManager.set_music("main_menu")
	change_world(world_index)

	left_button = world_select_gui.get_node("Left")
	right_button = world_select_gui.get_node("Right")
	left_button.pressed.connect(_on_left_pressed)
	right_button.pressed.connect(_on_right_pressed)

func _add_world_separator(node_world: Node, rel_position: Vector2):
	var world_separator = world_separator_scene.instantiate()
	node_world.add_child(world_separator)
	world_separator.position = rel_position


func _process(delta: float) -> void:
	$AnimationPlayer.play("background")

	# Lock left/right buttons
	if left_button:
		left_button.disabled = (world_index == 0)
	if right_button:
		right_button.disabled = (world_index == world.size()-1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_right"):
		increment_world_index()
	if event.is_action_pressed("game_left"):
		decrement_world_index()

# FUNCTIONS FOR WORLD SELECTION

func restore_position() -> void:
	change_world(world_index,true,false)

func increment_world_index(in_out = true) -> void:
	# world_index = (world_index + 1) % world.size()
	world_index = min(world.size()-1, world_index + 1)
	change_world(world_index, in_out)

func decrement_world_index(in_out = true) -> void:
	world_index = (world_index - 1)
	world_index = max(0, min(world.size()-1, world_index))
	# if world_index < 0:
	# 	world_index = world.size() - 1
	change_world(world_index, in_out)

func enable_button() -> void:
	if !is_timing:
		return
	is_timing = false
	LevelData.disable_level_button = false

func change_world(index: int, in_out = true, disable=true) -> void:
	if disable:
		LevelData.disable_level_button = true
	
	#erase previous timer
	for child in get_children():
		if child is Timer:
			child.stop()
			child.queue_free()
	var enable_button_timer = Timer.new()
	enable_button_timer.set_wait_time(0.5)
	enable_button_timer.one_shot = true
	add_child(enable_button_timer)
	enable_button_timer.start()
	is_timing = true
	enable_button_timer.timeout.connect(enable_button)
	
	LevelData.selected_world_index = index
	update_dot()
	var tween = null
	if world.size() == 0:
		LevelData.disable_level_button = false
		return
	for i in range(0, world.size()):
		if !get_tree():
			return
		tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		if in_out:
			tween.tween_property(node_worlds[i], "position:x", (i-world_index) * 16*15, 0.40).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(node_worlds[i], "position:x", (i-world_index) * 16*15, 0.70).set_ease(Tween.EASE_OUT)
	


# BUTTON HANDLE
func _on_left_pressed() -> void:
	decrement_world_index()
	pass # Replace with function body.


func _on_right_pressed() -> void:
	increment_world_index()
	pass # Replace with function body.

var dots : Array[Button]

func add_dot() -> void:
	var dot_scene = load("res://scenes/ui/world_select/dot_level_index.tscn")
	for i in range(0, world.size()):
		var dot : Button = dot_scene.instantiate()
		dot.index = i
		dots.append(dot)

		var dot_container = world_select_gui.get_node("MarginContainer/CenterContainer/DotContainer")
		dot_container.add_child(dot)
		pass

func update_dot() -> void:
	for i in range(0, world.size()):
		var dot : Button = dots[i]
		if dot and is_instance_valid(dot):
			if i == world_index:
				dot.icon = texture_on
			else:
				dot.icon = texture_off
			pass
