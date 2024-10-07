extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func error_shake():
	if animation_player.current_animation == "max_reached":
		return
	
	animation_player.play("max_reached")

func set_texture(texture):
	$StaticArrowSprite.texture = texture
	$AnimatedArrowSprite.texture = texture