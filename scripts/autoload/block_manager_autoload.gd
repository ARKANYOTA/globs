extends Node

var block_manager: PackedScene = preload("res://scenes/block_manager.tscn")
var block_manager_instance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_manager_instance = block_manager.instantiate()
	add_child(block_manager_instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
