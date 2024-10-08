extends Node2D

func reload() -> void:
    LevelData.reload_scene()

func _on_retry_block_on_glob_touched() -> void:
    reload()
    pass # Replace with function body.
