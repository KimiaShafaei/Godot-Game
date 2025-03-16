extends CharacterBody2D

@onready var raycast_front = $RayCast2D2_Front
@onready var raycast_left = $RayCast2D_Right
@onready var raycast_right = $RayCast2D_Left
@onready var shooting_raycast = $ShootingRayCast2D
@onready var enemy_anim = $AnimatedSprite2D
@onready var haering_area = $HearingArea2D
@onready var shooting_timer = $ShootingTimer

var shooting = false
var chasing = false
var player_in_sight = false

func _ready():
	haering_area.body_entered.connect(enter_hearing_area)
	shooting_timer.timeout.connect(shoot)
		
func increase_raycast(multiplier: float):
	raycast_front.target_position *= multiplier
	raycast_left.target_position *= multiplier
	raycast_right.target_position *= multiplier

func detect_player() -> bool:	
	return raycast_front.is_colliding() or raycast_left.is_colliding() or raycast_right.is_colliding()

func enter_hearing_area(body):
	if body.is_in_group("player"):
		print("enemy hears player")
		get_parent().start_chasing()

func start_shooting():
	print("start shooting")
	if not shooting:
		shooting = true
		shooting_timer.start(1.0)
		shooting_raycast.enabled = true
			
func stop_shooting():
	print("stop shooting")
	if shooting:
		shooting = false
		shooting_timer.stop()
		shooting_raycast.enabled = false

func shoot():
	print("shoot function call")
	print("Raycast enabled?", shooting_raycast.enabled)
	if shooting_raycast.is_colliding():
		var player = shooting_raycast.get_collider()
		print("raycast hit: ", player.name)
		print("shooting")
		if player and player.is_in_group("player"):
			print("player detected and damage")
			player.take_damage()
			enemy_anim.play(_get_shooting_anim())
		else:
			print("Raycast didn't detect the player!")
		
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
	
func _get_shooting_anim():
	if raycast_front.is_colliding():
		return "Shoot_down"
	elif raycast_left.is_colliding():
		return "Shoot_left"
	if raycast_right.is_colliding():
		return "Shoot_right"
	else:
		return "Shoot_up"
