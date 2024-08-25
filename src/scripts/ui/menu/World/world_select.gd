@tool
extends Node2D
class_name WorldSelect

@export var world: Array[ PackedScene]
@export var scroll: ScrollComponent
@export var dot_container : HBoxContainer 
var node_worlds : Array[Node2D]
var world_index = 0

func _ready():
	if world.size() == 0:
		return
	for i in range(0, world.size()):
		var node_world = world[i].instantiate()
		node_world.set_position(Vector2(i * 16*15, 0))
		node_worlds.append(node_world)
		scroll.add_child(node_world)
	add_dot()
	update_dot()
	world_index = LevelData.selected_world_index
	change_world(world_index)
pass

func _process(delta: float) -> void:
	$AnimationPlayer.play("background")
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		increment_world_index()
	if event.is_action_pressed("ui_left"):
		decrement_world_index()

# FUNCTIONS FOR WORLD SELECTION

func restore_position() -> void:
	change_world(world_index)

func increment_world_index(in_out = true) -> void:
	world_index = (world_index + 1) % world.size()
	change_world(world_index, in_out)

func decrement_world_index(in_out = true) -> void:
	world_index = (world_index - 1)
	if world_index < 0:
		world_index = world.size() - 1
	change_world(world_index, in_out)

#

func change_world(index: int, in_out = true) -> void:
	LevelData.selected_world_index = index
	update_dot()
	for i in range(0, world.size()):
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		if in_out:
			tween.tween_property(node_worlds[i], "position:x", (i-world_index) * 16*15, 0.40).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(node_worlds[i], "position:x", (i-world_index) * 16*15, 0.70).set_ease(Tween.EASE_OUT)
		pass


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
		dot_container.add_child(dot)
		pass
func update_dot() -> void:
	var icon_on = "res://assets/images/ui/world_index_dot_on.png"
	var icon_off = "res://assets/images/ui/world_index_dot.png"
	var texture_on : Texture2D = load(icon_on)
	var texture_off : Texture2D = load(icon_off)
	for i in range(0, world.size()):
		var dot : Button = dots[i]
		if i == world_index:
			dot.icon = texture_on
		else:
			dot.icon = texture_off
		pass

func _on_ui_button_pressed() -> void:
	LevelData.completed_levels = []
	LevelData.new_save_level_data()
	SceneTransitionAutoLoad.change_scene_with_transition("res://scenes/ui/world_select/world_select.tscn")
	pass # Replace with function body.
