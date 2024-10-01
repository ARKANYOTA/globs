extends Node

static var autorized_url = ["arkanyota.github.io", "yolwoocle.itch.io", "localhost", "html.itch.zone", "nine-sliced.github.io", "", "base_urls"]
static var is_autorized_url_loaded = false
		

func get_urls():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request("https://raw.githubusercontent.com/ARKANYOTA/gmtk2024/main/autorized_url.txt")
	var response = await http_request.request_completed
	var result = response[0]
	var status_code = response[1]
	var headers = response[2]
	var body = response[3]
	if result != 0 or status_code != 200:
		return []
	var json = JSON.parse_string(body.get_string_from_utf8())
	return json

	# result, status code, response headers, and body are now in indices 0, 1, 2, and 3 of response	
func is_url_valid() -> bool:
	if not OS.has_feature('web'):
		return true
	var location = JavaScriptBridge.get_interface("location")
	if not location:
		return true
	var hostname = location.hostname
	return hostname in autorized_url

var scene_transition: PackedScene = preload("res://scenes/ui/scene_transition.tscn")
var scene_transition_instance: Node
var pos_list : Array = [[0,32],[0,16],[16,32],[0,48]]
var youwinlevel: PackedScene = preload("res://scenes/ui/particle/you_win_level.tscn")
var youwinlevel_instance: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition_instance = scene_transition.instantiate()
	add_child(scene_transition_instance)
	if not OS.has_feature('web'):
		return

	if not is_autorized_url_loaded:
		is_autorized_url_loaded = true
		var urls = await get_urls()
		if urls == []:
			return
		autorized_url = urls

	#load the scene transition scene


func change_scene_with_transition(scene: String, put_confetis = false) -> void:
	PauseMenuAutoload.can_pause = false
	var root = get_tree().get_current_scene()
	# if put_confetis:
	# 	for i in root.get_children():
	# 		if i is Block and i.is_visible():
	# 			if i.is_main_character:
	# 				youwinlevel_instance = youwinlevel.instantiate()
	# 				i.add_child(youwinlevel_instance)
					
	var animation_player : AnimationPlayer = scene_transition_instance.get_node("AnimationPlayer")
	var transition_audio: AudioStreamPlayer2D = scene_transition_instance.get_node("TransitionAudio")
	var title_player : AnimationPlayer = scene_transition_instance.get_node("TitlePlayer")
	var title : Label = scene_transition_instance.get_node("WorldTitle")
	var slides = ["bloc_in"] # ,"block_in_vertical"]
	var random_slide_transition =  0 # randi_range(0, 0) # NOT USED
	# title.text = LevelData.names[LevelData.level - 1]
	set_random_sprite_transition()
	
	transition_audio.play()
	animation_player.play(slides[random_slide_transition])
	await animation_player.animation_finished
	if put_confetis:
		for i in root.get_children():
			if i is Block and i.is_visible():
				if i.is_main_character:
					var child_list = i.get_children()
					for particle in child_list:
						if particle.get_name() == "YouWinLevel":
							particle.queue_free()
	
	animation_player.play(slides[random_slide_transition], -1, -0.7, true)

	GameManager.before_scene_change()
	if is_url_valid() or scene in ["res://scenes/main.tscn", "res://scenes/ui/world_select/world_select.tscn", "res://scenes/levels_zoomed/world_1/level_110.tscn",  "res://scenes/levels_zoomed/world_1/level_120.tscn","res://scenes/levels_zoomed/world_1/level_130.tscn", "res://scenes/levels_zoomed/world_1/level_140.tscn"]:
		get_tree().change_scene_to_file(scene)
		await get_tree().process_frame
	else:
		get_tree().change_scene_to_file("res://scenes/ui/redirect_page_to_our_games.tscn")
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
	
