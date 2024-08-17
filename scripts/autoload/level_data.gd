extends Node

var levels = {
	1: { "name": "Level 1", "scene": "res://scenes/intro_level.tscn"},
	2: { "name": "Level 2", "scene": "res://scenes/guillaume_test.tscn"},
	3: { "name": "Level 3", "scene": "res://scenes/scene_2.tscn"},
}

var level = 1

func increment_level() -> void:
	level += 1
	if level > len(levels):
		assert(false, "Levvel out of bounds")
	save_level_data()

func save_level_data() -> void:
	var config = ConfigFile.new()
	config.set_value("level_section","level", level)
	config.save("user://level_data.cfg")

func load_level_data() -> void:
	var config = ConfigFile.new()
	config.load("user://level_data.cfg")
	level = config.get_value("level_section","level", level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("removeme2_nolan_usge_to_change_scene"):
		increment_level()
