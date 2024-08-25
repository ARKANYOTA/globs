extends CanvasLayer
class_name MenuManager

@onready var main = get_node("/root/Main")

var menu_stack: Array = []
var current_menu: Control = null

var music_bus_name := "Music"
@onready var _music_bus_index := AudioServer.get_bus_index(music_bus_name)

func _ready():
	pass

@export var texture: Texture:
	set(value):
		texture = value
		$Sprite2D.texture = texture 

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if PauseMenuAutoload.paused:
			back()
		else:
			pause()

func pause():
	if not PauseMenuAutoload.can_pause:
		return
	
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, true)
	PauseMenuAutoload.game_gui.hide_gui()

	PauseMenuAutoload.paused = true
	set_menu_by_name("PauseMenu")

func exit_menu():
	menu_stack = []
	PauseMenuAutoload.paused = false
	
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, false)
	
	hide()
	get_tree().set_pause(false)

func set_menu_by_name(menu_name: String, add_to_stack: bool = true):
	var menu: Control = get_node(str(menu_name))
	if not menu:
		return
	
	set_menu(menu, add_to_stack)

func set_menu(menu: Control, add_to_stack: bool = true):
	if not menu:
		return
	
	show()
	get_tree().set_pause(true)
	
	for child in get_children():
		child.hide()
	
	menu.show()
	current_menu = menu
	
	if add_to_stack:
		menu_stack.append(menu.name) 

func back():
	menu_stack.pop_back()
	if menu_stack.is_empty():
		exit_menu()
		PauseMenuAutoload.game_gui.show_correct_game_gui()
		return
	else:
		set_menu_by_name(menu_stack[-1], false)
