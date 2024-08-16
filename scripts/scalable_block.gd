@tool
extends CharacterBody2D

@export var dimensions: Vector2i = Vector2i(16, 16):
	set(value):
		dimensions = value
		var collision_shape = $CollisionShape
		var shape = collision_shape.shape
		if shape is not RectangleShape2D:
			print("$CollisionShape.shape is not a RectangleShape2D")
			return
		shape.size = value
		
		var child_pos: Vector2 = Vector2(dimensions)/2
		collision_shape.position = child_pos
		update_sprite_size(child_pos)

func update_sprite_size(pos):
	var sprite: Sprite2D = $Sprite
	
	sprite.position = pos
	
	var sprite_size = sprite.texture.get_size()
	sprite.scale.x = dimensions.x / sprite_size.x
	sprite.scale.y = dimensions.y / sprite_size.y

func _ready():
	pass

func _physics_process(delta):
	move_and_slide()
