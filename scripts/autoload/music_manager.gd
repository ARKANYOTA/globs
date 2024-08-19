extends Node

@onready var audio_player

var music_player_prefab: PackedScene = load("res://scenes/music/music_player.tscn")
var music_player: MusicPlayer

var streams = {
	"main_menu" = load("res://assets/sounds/music/music_cheese_world.mp3"),
	"city" = load("res://assets/sounds/music/music_snow_world.mp3"),
	"cheese" = load("res://assets/sounds/music/music_cheese_world.mp3"),
	"snow" = load("res://assets/sounds/music/music_snow_world.mp3"),
}
var current_music_name: String = "main_menu"

func _ready():
	music_player = music_player_prefab.instantiate()
	add_child(music_player)
	
	set_music("main_menu")
	music_player.play()

func set_music(music_name: String):
	if music_name == current_music_name:
		return
	
	var stream: AudioStream = streams[music_name]
	if not stream:
		return
	
	current_music_name = music_name
	music_player.stop()
	music_player.set_stream(stream)
	music_player.play()

func _process(delta):
	pass
