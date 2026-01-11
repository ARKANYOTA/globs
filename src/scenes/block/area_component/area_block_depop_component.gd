extends Node2D

@export var smoke_scene: PackedScene

func _on_glob_touched(area:Block):
	var smoke: SmokeParticle = smoke_scene.instantiate()
	smoke.global_position = area.global_position
	get_tree().current_scene.add_child(smoke)
	area.hide_block()

	AchievementData.increment_retry_area_count()
