extends HSlider
# Thanks to https://www.gdquest.com/tutorial/godot/audio/volume-slider/

@export var audio_bus_name := "Master"

var music_bus_name := "Music"
@onready var _music_bus_index := AudioServer.get_bus_index(music_bus_name)

func _ready() -> void:
	value = GameManager.load_option("volume", audio_bus_name, 1.0)

func _on_value_changed(input_value: float) -> void:
	GameManager.set_bus_volume(audio_bus_name, input_value)
	GameManager.save_option("volume", audio_bus_name, value)

func _on_drag_started():
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, false)

func _on_drag_ended(_value_changed: bool):
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, true)

