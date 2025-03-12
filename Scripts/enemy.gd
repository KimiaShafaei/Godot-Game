extends CharacterBody2D

@onready var raycast_front = $RayCast2D2_Front
@onready var raycast_left = $RayCast2D_Right
@onready var raycast_right = $RayCast2D_Left
@onready var enemy_anim = $AnimatedSprite2D

func increase_raycast(multiplier: float):
	raycast_front.target_position *= multiplier
	raycast_left.target_position *= multiplier
	raycast_right.target_position *= multiplier
	print("inscreasing raycast")

func detect_player() -> bool:
	if raycast_front.is_colliding():
		print("raycast front colliding with player")
	if raycast_left.is_colliding():
		print("raycast left colliding with player")
	if raycast_right.is_colliding():
		print("raycast right colliding with player")
		
	return raycast_front.is_colliding() or raycast_left.is_colliding() or raycast_right.is_colliding()
	
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
	
