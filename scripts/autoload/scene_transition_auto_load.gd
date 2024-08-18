extends Node

var scene_transition: PackedScene = preload("res://scenes/scene_transition.tscn")
var scene_transition_instance: Node
var pos_list : Array = [[0,32],[0,16],[16,32],[0,48]]
var youwinlevel: PackedScene = preload("res://scenes/you_win_level.tscn")
var youwinlevel_instance: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load the scene transition scene
	scene_transition_instance = scene_transition.instantiate()
	add_child(scene_transition_instance)
	youwinlevel_instance = youwinlevel.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene_with_transition(scene: String) -> void:
	var root = get_tree().get_current_scene()
	for i in root.get_children():
		if i is Block:
			if i.is_main_character:
				i.add_child(youwinlevel_instance)
	var animation_player : AnimationPlayer = scene_transition_instance.get_node("AnimationPlayer")
	var transition_audio: AudioStreamPlayer2D = scene_transition_instance.get_node("TransitionAudio")
	var title_player : AnimationPlayer = scene_transition_instance.get_node("TitlePlayer")
	var title : Label = scene_transition_instance.get_node("WorldTitle")
	var slides = ["bloc_in","block_in_vertical"]
	var random_slide_transition = randi_range(0, 0) # NOT USED
	# title.text = LevelData.names[LevelData.level - 1]
	set_random_sprite_transition()
	
	transition_audio.play()
	animation_player.play(slides[random_slide_transition])
	await animation_player.animation_finished

	for i in root.get_children():
		if i is Block:
			if i.is_main_character:
				i.remove_child(youwinlevel_instance)
	
	GameManager.before_scene_change()
	get_tree().change_scene_to_file(scene)

	animation_player.play(slides[random_slide_transition], -1, -0.7, true)
	#title_player.play("WorldLevel")
	pass

func set_random_sprite_transition():
	var up : NinePatchRect = scene_transition_instance.get_node("up")
	var down : NinePatchRect = scene_transition_instance.get_node("down")

	var random_len = randi_range(0, pos_list.size() - 1)
	var random_len_2 = randi_range(0, pos_list.size() - 1)
	var region_rect : Rect2 = Rect2(pos_list[random_len][0], pos_list[random_len][1], 16, 16)
	var region_rect_2 : Rect2 = Rect2(pos_list[random_len_2][0], pos_list[random_len_2][1], 16, 16)

	up.region_rect = region_rect
	down.region_rect = region_rect_2
	
