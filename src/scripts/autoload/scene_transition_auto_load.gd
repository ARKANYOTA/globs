extends Node

var scene_transition: PackedScene = preload("res://scenes/ui/scene_transition.tscn")
var scene_transition_instance: Node
var pos_list : Array = [[0,32],[0,16],[16,32],[0,48]]
var youwinlevel: PackedScene = preload("res://scenes/ui/particle/you_win_level.tscn")
var youwinlevel_instance: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load the scene transition scene
	scene_transition_instance = scene_transition.instantiate()
	add_child(scene_transition_instance)
	youwinlevel_instance = youwinlevel.instantiate()

func change_scene_with_transition(scene: String, put_confetis = false) -> void:
	PauseMenuAutoload.can_pause = false
	var root = get_tree().get_current_scene()
	if put_confetis:
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
	if put_confetis:
		for i in root.get_children():
			if i is Block:
				if i.is_main_character:
					i.remove_child(youwinlevel_instance)
	
	animation_player.play(slides[random_slide_transition], -1, -0.7, true)

	GameManager.before_scene_change()
	get_tree().change_scene_to_file(scene)
	await get_tree().process_frame
	
	# Music 	
	#title_player.play("WorldLevel")
	PauseMenuAutoload.game_gui.show_correct_game_gui()
	await animation_player.animation_finished

	if get_tree().get_current_scene() and get_tree().get_current_scene().get_name() != "Main": # menu d'acceuil
		PauseMenuAutoload.can_pause = true
	
func set_random_sprite_transition():
	var up : NinePatchRect = scene_transition_instance.get_node("PanelContainer/PanelUp")
	var down : NinePatchRect = scene_transition_instance.get_node("PanelContainer/PanelDown")

	var random_len = randi_range(0, pos_list.size() - 1)
	var random_len_2 = randi_range(0, pos_list.size() - 1)
	var region_rect : Rect2 = Rect2(pos_list[random_len][0], pos_list[random_len][1], 16, 16)
	var region_rect_2 : Rect2 = Rect2(pos_list[random_len_2][0], pos_list[random_len_2][1], 16, 16)

	up.region_rect = region_rect
	down.region_rect = region_rect_2
	
