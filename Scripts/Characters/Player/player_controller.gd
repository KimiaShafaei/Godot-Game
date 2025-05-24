extends CharacterBody2D

class_name Player

@export var speed = 200
@export var runnig_speed = 400
@export var healths = 3
@export var invisibility_color: Color = Color(1, 1, 1, 0.4)

@onready var anim = $PlayerAnimatedSprite2D
@onready var tile_map = get_node("../TileMapLayer")
@onready var walking_sound = $walking
@onready var background_sound = get_node("../background")
@onready var blood_anim = $Blood
@onready var health_bar = get_node("../ProgressBar/HealthBar")
@onready var state_manager = $StateManager
@onready var invisible_sound = $InvisibilitySound
@onready var invisible_timer = $InvisibilityTimer
@onready var nva_agent: NavigationAgent2D = $NVAagent

var _path: Array = []
var _current_index = 0
var _last_side: String = "down"
var start_chasing = false

func _ready():
	anim.play("Idle_down")
	background_sound.play()
	blood_anim.visible = false
	state_manager.init(self)
	state_manager.change_state("IdleState")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = tile_map.round_local_position(get_global_mouse_position())
		var click_enemy = get_click_enemy(click_position)

		if click_enemy:
			state_manager.set_attack_target(click_enemy)
			state_manager.change_state("AttackState")
		elif tile_map.is_point_walkable(click_position):
			_path = tile_map.find_path(global_position, click_position)
			_current_index = 0
			state_manager.change_state("WalkingState")

	state_manager._input(event)

func _physics_process(delta):
	state_manager._physics_process(delta)

func _update_animation(direction):
	if direction.length() > 0:
		if start_chasing:
			_play_run_animation(direction)
		else:
			_play_walk_animation(direction)

	if direction.length() > 0 and not walking_sound.playing:
		walking_sound.play()

func _play_walk_animation(direction):
	if abs(direction.x) > abs(direction.y):
		anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		anim.play("Walk_%s" % _last_side)
	else:
		_last_side = "down" if direction.y > 0 else "up"
		anim.play("Walk_%s" % _last_side)

func _play_run_animation(direction):
	if abs(direction.x) > abs(direction.y):
		anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		anim.play("Run_%s" % _last_side)
	else:
		_last_side = "down" if direction.y > 0 else "up"
		anim.play("Run_%s" % _last_side)

func _play_idle():
	anim.flip_h = false
	anim.play("Idle_%s" % _last_side)

	if walking_sound.playing:
		walking_sound.stop()

func start_running():
	if not start_chasing:
		start_chasing = true
		speed = runnig_speed

func get_click_enemy(click_position):
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.global_position.distance_to(click_position) < 30:
			return enemy
	return null

func attack_to_enemy(enemy):
	if global_position.distance_to(enemy.global_position) < 40:
		anim.play("Attack_%s" % _last_side)
		await anim.animation_finished
		enemy.take_damage()

func take_damage():
	healths -= 1
	health_bar.value = healths

	blood_anim.visible = true
	blood_anim.play("Blood2")

	if healths > 0:
		state_manager.change_state("HitState")
	else:
		state_manager.change_state("DieState")
