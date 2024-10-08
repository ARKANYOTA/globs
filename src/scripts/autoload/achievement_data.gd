extends Node

var retry_area_count: int = 0
var achivement_area_retry = 1
var game_manager : GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increment_retry_area_count() -> void:
	retry_area_count += 1
	if retry_area_count >= achivement_area_retry:
		GameManager.achievement_manager.grant("ACH_GLOBS_IN_VOID_10_TIMES")