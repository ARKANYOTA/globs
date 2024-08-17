extends Node2D

var selected_level = 1

func _ready():
    print(LevelData.level)

# on input event
func _input(event):
    if event.is_action_pressed("ui_right"):
        selected_level = max(LevelData.level, selected_level + 1)
    elif event.is_action_pressed("ui_left"):
        selected_level = min(1, selected_level - 1)
    elif event.is_action_pressed("ui_select"):
        LevelData.level = selected_level
        print("change scene to ", LevelData.levels[selected_level].scene)
        #get_tree().change_scene(LevelData.levels[selected_level].scene)