extends HSlider
# Thanks to https://www.gdquest.com/tutorial/godot/audio/volume-slider/

@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))

func _on_value_changed(value: float) -> void:
	var config = ConfigFile.new()
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	config.set_value("volume", audio_bus_name, value)
	config.save("user://volume.cfg")

