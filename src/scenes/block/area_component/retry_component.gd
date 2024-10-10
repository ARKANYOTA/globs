extends Node2D
@export var achievement = false
func reload() -> void:
	if achievement:
		print("ACH_GLOBS_IN_VOID_5_TIMES")
		AchievementData.increment_retry_area_count()
	LevelData.reload_scene()

func _on_retry_block_on_glob_touched() -> void:
	reload()
	pass # Replace with function body.
