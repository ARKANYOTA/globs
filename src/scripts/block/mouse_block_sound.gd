extends AudioStreamPlayer2D

var has_played = false
@export var block_name := "mouse"
@export var mouse_pitch_scale := 0.7
@export var bear_pitch_scale := 0.7
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_click_area_clicked() -> void:
	# Play the sound
	if !has_played:
		if block_name == "mouse":
			pitch_scale = mouse_pitch_scale
			play()
		if block_name == "bear":
			pitch_scale = bear_pitch_scale
			play()
			#lower pitch scale to 0.3
	has_played = true

func _on_un_click_area_clicked_outside_area() -> void:
	has_played = false
