extends Node2D
class_name MusicPlayer

@onready var audio_stream: AudioStreamPlayer2D = $AudioPlayer

func play():
	audio_stream.play()

func stop():
	audio_stream.play()
