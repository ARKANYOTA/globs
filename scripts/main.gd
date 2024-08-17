extends Node2D
class_name Main

@onready var menu_manager: MenuManager = $MenuManager
@onready var pause_menu = $MenuManager/PauseMenu
@onready var game = $Game
@export var current_scene: int = 1
@export var number_of_scene: int = 2

var paused = false

func get_current_level():
	return game.get_child(0)

func set_scene(scene_number: int):
	current_scene = scene_number
	change_scene()

func change_scene():
	var nb_child_of_game = game.get_child_count(false)
	if current_scene > number_of_scene:
		assert("la scene courante est plus elvé que le nombre de scene")
		print("la scene courante est plus elvé que le nombre de scene")
	var load_scene: Node2D = load("res://scenes/scene_" + str(current_scene) + ".tscn").instantiate()
	
	if nb_child_of_game == 1:
		game.remove_child(game.get_children(false)[0])
	elif nb_child_of_game == 0:
		pass
	else: 
		assert("Hé ho trop de fils a Game, il en faut qu'un") 
	
	game.add_child(load_scene)

func _ready():
	menu_manager.visible = true
	menu_manager.exit_menu()

func _process(delta):
	pass

# Quitting 
func quit():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("removeme2_nolan_usge_to_change_scene"):
		current_scene += 1
		change_scene()
