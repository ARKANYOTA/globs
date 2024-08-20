extends Node

@onready var pause_menu_file = preload("res://scenes/ui/menu/menu_manager.tscn")
@onready var escape_button_file = preload("res://scenes/ui/escape_button.tscn")
var pause_menu: Node
var escape_button: Node

var can_pause = true
var is_skip_enabled = true
var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = pause_menu_file.instantiate()
	add_child(pause_menu)
	escape_button = escape_button_file.instantiate()
	add_child(escape_button)
