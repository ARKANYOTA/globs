extends Node2D

func reload() -> void:
    AchievementData.increment_retry_area_count()
    LevelData.reload_scene()

func _on_retry_block_on_glob_touched() -> void:
    reload()
    pass # Replace with function body.
