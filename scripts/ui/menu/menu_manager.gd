extends CanvasLayer
class_name MenuManager

@onready var main = get_node("/root/Main")

var menu_stack: Array = []
var current_menu: Control = null
var paused: bool = false

func _ready():
	pass

@export var texture: Texture:
	set(value):
		texture = value
		$Sprite2D.texture = texture 

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			back()
		else:
			pause()

func pause():
	if not PauseMenuAutoload.can_pause:
		return
	paused = true
	set_menu_by_name("PauseMenu")

func exit_menu():
	menu_stack = []
	paused = false
	
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
		return
	else:
		set_menu_by_name(menu_stack[-1], false)
