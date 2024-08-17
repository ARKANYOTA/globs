extends Node

var scene_transition: PackedScene = preload("res://scenes/scene_transition.tscn")
var scene_transition_instance: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load the scene transition scene
	scene_transition_instance = scene_transition.instantiate()
	add_child(scene_transition_instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene_with_transition(scene: String) -> void:
	var animation_player : AnimationPlayer = scene_transition_instance.get_node("AnimationPlayer")
	animation_player.play("bloc_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	animation_player.play("bloc_in", -1, -0.7, true)
	pass
