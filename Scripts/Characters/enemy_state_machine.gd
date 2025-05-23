extends Node

@onready var enemy_anim = $AnimatedSprite2D

func _update_animation(direction:  Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			enemy_anim.play("Walk_right")
		else:
			enemy_anim.play("Walk_left")
	else :
		if direction.y > 0:
			enemy_anim.play("Walk_down")
		else :
			enemy_anim.play("Walk_up")
