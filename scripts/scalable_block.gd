@tool
extends CharacterBody2D

@export var dimensions: Vector2 = Vector2(16, 16):
	set(value):
		dimensions = value
		var shape = $CollisionShape.shape
		if shape is not RectangleShape2D:
			print("not a rect")
			return
		shape.size = value
		
		update_sprite_size()

func update_sprite_size():
	var sprite: Sprite2D = $Sprite
	
	var sprite_size = sprite.texture.get_size()
	sprite.scale.x = dimensions.x / sprite_size.x
	sprite.scale.y = dimensions.y / sprite_size.y

func _ready():
	pass

func _physics_process(delta):
	move_and_slide()
