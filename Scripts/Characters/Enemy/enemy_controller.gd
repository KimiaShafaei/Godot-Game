extends CharacterBody2D

@export var speed = 50 
@export var running_speed = 80
@export var chase_range_multiple = 5
@export var attack_distance = 50
@export var healths = 1

@onready var enemy_anim = $AnimatedSprite2D
@onready var tile_map = get_node("../../../TileMapLayer")
@onready var hearing_area = $HearingArea2D
@onready var understanding_sonud = $understanding
@onready var chase_timer = $ChasingTimer
@onready var blood_anim = $Blood
@onready var path_follow = $".."
@onready var raycast_front = $RayCast2D2_Front
@onready var raycast_left = $RayCast2D_Left
@onready var raycast_right = $RayCast2D_Right
@onready var state_manager = $StateManger

var _last_side: String = "down"
var player = null
var chasing = false

func _ready():
	enemy_anim.play("Idle_down")
	blood_anim.visible = false
	state_manager.init(self)
	print(state_manager)
	state_manager.change_state("IdleState")
	player = get_tree().get_first_node_in_group("player")

	hearing_area.body_entered.connect(enter_hearing_area)

func _physics_process(delta):
	state_manager._physics_process(delta)

func _play_idle():
	enemy_anim.flip_h = false
	enemy_anim.play("Idle_%s" % _last_side)

func _play_walk_animation(direction):
	if abs(direction.x) > abs(direction.y):
		enemy_anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_anim.play("Walk_%s" % _last_side)
	else:
		enemy_anim.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_anim.play("Walk_%s" % _last_side)

func _play_run_animation(direction):
	if abs(direction.x) > abs(direction.y):
		enemy_anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_anim.play("Run_%s" % _last_side)
	else:
		enemy_anim.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_anim.play("Run_%s" % _last_side)

func start_running():
	if not chasing:
		chasing = true
		speed = running_speed


func enter_hearing_area(body):
	if body.is_in_group("player"):
		state_manager.change_state("ChasingState")

func detect_player() -> bool:
	return raycast_front.is_colliding() or raycast_left.is_colliding() or raycast_right.is_colliding()

func increase_raycast(multiplier: float):
	raycast_front.target_position *= multiplier
	raycast_left.target_position *= multiplier
	raycast_right.target_position *= multiplier

func reset_raycast():
	raycast_front.target_position = Vector2(50, 0)
	raycast_left.target_position = Vector2(-50, 0)
	raycast_right.target_position = Vector2(0, 50)

func _play_attack_to_player():
	enemy_anim.play("Attack_%s" % _last_side)
	await enemy_anim.animation_finished

func take_damage():
	healths -= 1
	if healths > 0 :
		state_manager.change_state("HitState")
	else :
		state_manager.change_state("DieState")

func _play_die_animation():
	blood_anim.visible = true
	blood_anim.play("Blood2")
	await blood_anim.animation_finished
	blood_anim.visible = false	
	enemy_anim.play("Die_%s" % _last_side)
