extends HSlider
# Thanks to https://www.gdquest.com/tutorial/godot/audio/volume-slider/

@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	pass

func _on_value_changed(input_value: float) -> void:
	GameManager.save_option("volume", audio_bus_name, value)
	AudioServer.set_bus_volume_db(_bus, linear_to_db(input_value))


# func _old_on_value_changed(input_value: float) -> void:
# 	var config = ConfigFile.new()
# 	config.load("user://volume.cfg")

# 	var music_value = config.get_value("Sound", "Music", 1)
# 	var master_value = config.get_value("Sound", "Master", 1)
# 	config.set_value("Sound", "Music", music_value)
# 	config.set_value("Sound", "Master", master_value)
# 	if audio_bus_name == "Master":
# 		config.set_value("Sound", "Master", input_value)
# 	else:
# 		config.set_value("Sound", "Music", input_value)
# 	config.save("user://volume.cfg")
	
# 	AudioServer.set_bus_volume_db(_bus, linear_to_db(input_value))
