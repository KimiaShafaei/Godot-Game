extends CharacterBody2D

@export var speed = 50 
@export var running_speed = 80
@export var default_detect_area: Vector2 = Vector2(20, 20)
@export var chase_range_multiple = 3
@export var attack_distance = 50
@export var healths = 1

@onready var enemy_anim = $EnemyAnimatedSprite2D
@onready var tile_map = get_node("../../../TileMapLayer")
@onready var chase_timer = $ChasingTimer
@onready var blood_anim = $BloodAnimatedSprite
@onready var path_follow = $".."
@onready var detect_area = $DetectArea
@onready var state_manager = $StateManger

var _last_side: String = "down"
var player = null
var chasing = false
var player_in_detect_area = false

func _ready():
	enemy_anim.play("Idle_down")
	blood_anim.visible = false
	state_manager.init(self)
	state_manager.change_state("WalkingState")
	player = get_tree().get_first_node_in_group("player")

	detect_area.body_entered.connect(on_body_entered)
	detect_area.body_exited.connect(on_body_exited)

func _physics_process(delta):
	state_manager._physics_process(delta)

func on_body_entered(body):
	if body.is_in_group("player"):
		player_in_detect_area = true
		player = body
		state_manager.change_state("ChasingState")

func on_body_exited(body):
	if body.is_in_group("player"):
		player_in_detect_area = false
		player = null
		state_manager.change_state("WalkingState")

func detect_player() -> bool:
	return player_in_detect_area
	
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

func _play_attack_to_player():
	enemy_anim.play("Attack_%s" % _last_side)
	await enemy_anim.animation_finished

func _play_die_animation():
	blood_anim.visible = true
	blood_anim.play("Blood2")
	await blood_anim.animation_finished
	blood_anim.visible = false	
	enemy_anim.play("Death_%s" % _last_side)
