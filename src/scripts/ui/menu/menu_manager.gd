extends CanvasLayer
class_name MenuManager

var menu_stack: Array = []
var current_menu: Control = null

var music_bus_name := "Music"
@onready var _music_bus_index := AudioServer.get_bus_index(music_bus_name)

# This is necessary because the "Back" notification is called twice on Android... for some reason...
var back_cooldown = 0.1
var back_cooldown_timer = 0.0

func _ready():
	pass

@export var texture: Texture:
	set(value):
		texture = value
		$Sprite2D.texture = texture 

func _process(delta):
	back_cooldown_timer = max(0.0, back_cooldown_timer - delta)

func pause():
	if not PauseMenuAutoload.can_pause:
		return
	
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, true)
	PauseMenuAutoload.game_gui.hide_gui()

	PauseMenuAutoload.paused = true
	set_menu("PauseMenu")

func exit_menu():
	menu_stack = []
	PauseMenuAutoload.paused = false
	
	AudioServer.set_bus_effect_enabled(_music_bus_index, 0, false)
	
	hide()
	get_tree().set_pause(false)

func set_menu(menu_name: String, add_to_stack: bool = true):
	var menu: Control = get_node_or_null(str(menu_name))
	if not menu:
		return
	
	set_menu_by_node(menu, add_to_stack)

func set_menu_by_node(menu: Control, add_to_stack: bool = true):
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
	if back_cooldown_timer > 0:
		return
	back_cooldown_timer = back_cooldown

	menu_stack.pop_back()
	if menu_stack.is_empty():
		exit_menu()
		PauseMenuAutoload.game_gui.show_correct_game_gui()
		return
	else:
		set_menu(menu_stack[-1], false)


# TODO on PC, key "escape" = back
func _input(event):	
	if event.is_action_pressed("pause"):
		if PauseMenuAutoload.paused:
			back()
		else:
			pause()


func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		back()

