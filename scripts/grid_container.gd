extends GridContainer

var LevelButton = preload("res://scenes/level_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var len_list = len(LevelData.levels)
	for i in range(len_list - 1):
		var button = LevelButton.instantiate()
		button.level = i
		add_child(button)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
