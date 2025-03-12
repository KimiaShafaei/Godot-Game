extends CharacterBody2D

@onready var raycast_front = $RayCast2D2_Front
@onready var raycast_left = $RayCast2D_Right
@onready var raycast_right = $RayCast2D_Left
@onready var enemy_anim = $AnimatedSprite2D
@onready var haering_area = $HearingArea2D

func _ready():
	haering_area.body_entered.connect(enter_hearing_area)
	
func increase_raycast(multiplier: float):
	raycast_front.target_position *= multiplier
	raycast_left.target_position *= multiplier
	raycast_right.target_position *= multiplier
	print("increasing raycast")

func detect_player() -> bool:	
	return raycast_front.is_colliding() or raycast_left.is_colliding() or raycast_right.is_colliding()

func enter_hearing_area(body):
	if body.is_in_group("player"):
		print("enemy hears player")
		get_parent().start_chasing()
		
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
	
