extends Node

@onready var audio_player

var music_player_prefab: PackedScene = load("res://scenes/music_player.tscn")
var music_player: MusicPlayer

func _ready():
	music_player = music_player_prefab.instantiate()
	add_child(music_player)
	
	music_player.play()

func _process(delta):
	pass
