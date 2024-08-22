@tool
extends Button
class_name ClickArea

signal clicked
signal clicked_outside_area
signal start_drag
signal dragging
signal end_drag

# @export var size: Vector2i:
# 	set(value):
# 		size = value
# 		var shape = $ClickAreaCollisionShape
# 		if shape:
# 			$ClickAreaCollisionShape.shape.size = Vector2(value)

# @export var debug_color: Color = Color(1, 0, 1, 0.5):
# 	set(value):
# 		debug_color = value
# 		var shape = $ClickAreaCollisionShape
# 		if shape:
# 			$ClickAreaCollisionShape.debug_color = value

var is_enabled := true
var is_hovered := false
var is_held := false

##################################################

# func _ready():
# 	$ClickAreaCollisionShape.shape = $ClickAreaCollisionShape.shape.duplicate()

func _input(_event):
	if Engine.is_editor_hint():
		return
	
	if not is_enabled:
		return
	
	# if event.is_action_pressed("left_click"): #TODO
	# 	clicked_outside_area.emit()


func _process(_delta):
	if Engine.is_editor_hint():
		return
	
	if is_held:
		dragging.emit()

func _on_mouse_entered():
	if Engine.is_editor_hint():
		return
	
	is_hovered = true

func _on_mouse_exited():
	if Engine.is_editor_hint():
		return
	
	is_hovered = false


func set_click_area_size_and_position(new_size: Vector2, new_position: Vector2):
	position = new_position - new_size/2
	size = new_size
	

func _on_clicked():
	pass # Replace with function body.


func _on_button_down():
	clicked.emit()
	start_drag.emit()
	is_held = true


func _on_button_up():
	is_held = false
	end_drag.emit()