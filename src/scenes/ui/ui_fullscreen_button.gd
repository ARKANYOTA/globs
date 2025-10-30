extends UIButton

var icon_on = preload("res://assets/images/ui/fullscreen_on.png")
var icon_off = preload("res://assets/images/ui/fullscreen_off.png")

func _ready():
	super()
	visible = (GameManager.game_platform != GameManager.GamePlatform.MOBILE)


func _process(_delta):
	update_icon()

func _on_pressed():
	super._on_pressed()
	GameManager.toggle_fullscreen()
	update_icon()

func update_icon():
	if GameManager.is_fullscreen:
		icon = icon_on
		text = (tr("MENU_OPTIONS_FULLSCREEN") + " · " + tr("MENU_YES"))
	else:
		icon = icon_off
		text = (tr("MENU_OPTIONS_FULLSCREEN") + " · " + tr("MENU_NO"))

func _on_mouse_entered():
	super._on_mouse_entered()
	
	
