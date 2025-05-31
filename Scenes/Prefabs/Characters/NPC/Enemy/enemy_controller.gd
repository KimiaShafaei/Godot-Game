extends CharacterBody2D

class_name Enemy

var world
var tile_map

@export var distance_to_shoot: float = 50

@export var enemy_healths: int = 1
@export var speed: int = 100

@onready var enemy_sprite: AnimatedSprite2D = $EnemyAnimatedSprite2D
@onready var detect_sound = $DetectSound
@onready var shoot_sound = $ShootingSound
@onready var blood_anim = $BloodAnimatedSprite
@onready var state_manager = $StateManager

var direction: Vector2
var _path: Array = []
var _current_index = 0
var _last_side: String = "down"
var player_detected = false

func _ready():
	enemy_sprite.play("Idle_down")
	blood_anim.visible = false
	world = get_parent()
	tile_map = world.map
	state_manager.init(self)
	state_manager.change_state("IdleState")

#region MotionHandling
func _process(_delta: float) -> void:
	if player_detected and global_position.distance_to(world.player.position) < distance_to_shoot:
		state_manager.change_state("AttackState")
	
	if !player_detected:
		state_manager.change_state("PatrollingState")

func _physics_process(_delta: float) -> void:
	if _path.is_empty():
		await set_timer(5)
		state_manager.change_state("IdleState")
		return
		
	move_in_tileset()
		
		
func go_to_player_position() -> void:
		var player_position = tile_map.round_local_position(world.player.global_position)
		_path = tile_map.find_path(global_position, player_position, false)
		
func move_in_tileset() -> void:
	var target = tile_map.map_to_local(_path[_current_index])
	direction = (target - global_position).normalized()
	velocity = direction * speed
	_update_animation()

	if global_position.distance_to(target) < 10:
		_current_index += 1
	
	if _current_index >= _path.size():
		reset_path()

	var prev_position = global_position
	move_and_slide()

	if global_position.distance_to(prev_position) < 1:
		_play_idle()
		
		
		
func go_to_position(next_position: Vector2) -> void:
		var round_next_position = tile_map.round_local_position(next_position)
		_path = tile_map.find_path(global_position, round_next_position, false)
		
func reset_path() -> void:
	_path.clear()
	_current_index = 0
#endregion

#region AnimationHandling
func _update_animation():
	if direction.length() > 0:
		if player_detected:
			_play_run()
		else:
			_play_walk()

func _play_idle() -> void:
	enemy_sprite.flip_h = false
	enemy_sprite.play("Idle_%s" % _last_side)

func _play_walk() -> void:
	if abs(direction.x) > abs(direction.y):
		enemy_sprite.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_sprite.play("Walk_%s" % _last_side)
	else:
		enemy_sprite.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_sprite.play("Walk_%s" % _last_side)

func _play_run() -> void:
	if abs(direction.x) > abs(direction.y):
		enemy_sprite.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_sprite.play("Run_%s" % _last_side)
	else:
		enemy_sprite.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_sprite.play("Run_%s" % _last_side)

func _play_attack() -> void:
	enemy_sprite.play("Attack_%s" % _last_side)
	await enemy_sprite.animation_finished

func die_enemy() -> void:
	blood_anim.visible = true
	blood_anim.play("Blood2")
	await blood_anim.animation_finished
	enemy_sprite.play("Die_%s" % _last_side)
	await enemy_sprite.animation_finished
#endregion


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":

		state_manager.change_state("ChasingState")
		player_detected = true
		reset_path()
		go_to_player_position()
		
		if detect_sound and not detect_sound.playing and player_detected:
			detect_sound.play()
			await set_timer(5.0)
			player_detected = false
			state_manager.change_state("SearchingState")

func set_timer(time: float) -> Signal:
	return get_tree().create_timer(time).timeout
