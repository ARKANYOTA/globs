extends Node

@onready var pause_menu_file = preload("res://scenes/ui/menu/menu_manager.tscn")
var pause_menu: Node

var can_pause = true
var is_skip_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = pause_menu_file.instantiate()
	add_child(pause_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#is_skip_enabled = GameManager.restarts >= 5
	pass
