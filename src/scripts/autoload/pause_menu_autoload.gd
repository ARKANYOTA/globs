extends Node

@onready var pause_menu_file = preload("res://scenes/ui/menu/menu_manager.tscn")
@onready var game_gui_file = preload("res://scenes/ui/game_gui.tscn")
var pause_menu: Node
var game_gui: Node

var can_pause = true
var is_skip_enabled = true
var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = pause_menu_file.instantiate()
	add_child(pause_menu)
	game_gui = game_gui_file.instantiate()
	add_child(game_gui)
