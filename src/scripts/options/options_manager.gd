extends Node
class_name OptionsManager

const OPTIONS_FILE_PATH = "user://options.cfg"

var config = ConfigFile.new()

func _init():
	var err = config.load(OPTIONS_FILE_PATH)
	if err != OK:
		print("Error loading options file. Defaults will be used. Error code: ", err)
	else:
		print("Loaded options file successfully.")


func save(section: String, key: String, value: Variant) -> bool:
	config.set_value(section, key, value)
	return config.save(OPTIONS_FILE_PATH) == OK


func load(section: String, key: String, default_value: Variant):
	return config.get_value(section, key, default_value)
