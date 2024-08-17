extends Node

@onready var pause_menu = preload("res://scenes/menu_manager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu = pause_menu.instantiate()
	add_child(pause_menu)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
