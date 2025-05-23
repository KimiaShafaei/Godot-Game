extends CharacterBody2D

enum ENEMY_STATES {PATROLLING, CHASING, SEARCHING}

@export var FOV: Dictionary = {
	ENEMY_STATES.PATROLLING: 60.0,
	ENEMY_STATES.CHASING: 120.0,
	ENEMY_STATES.SEARCHING: 100.0
}

@export var SPEED: Dictionary = {
	ENEMY_STATES.PATROLLING: 60.0,
	ENEMY_STATES.CHASING: 100.0,
	ENEMY_STATES.SEARCHING: 80.0
}

#it should assine to paths node2D (wayponints is in path node)
@export var patrol_points: NodePath
@export var enemy_healths: int = 1

#it's a sprite2d node in enemy charecterBody2D node
@onready var enemy_sprite: Sprite2D = $EnemyAnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
#It's a node2D thats a raycast2D node in it
@onready var player_detect = $PlayerDetect
@onready var detect_raycast = $Raycast2D
@onready var detect_sound = $understanding
@onready var chase_timer = $ChasingTimer
@onready var shoot_timer = $ShootingTimer
@onready var shoot_sound = $ShootingSound
@onready var blood_anim = $BloodAnimatedSprite

var _last_side: String = "down"
var _waypoints: Array = []
var curr_waypoint: int = 0
var _player_ref: Player
var _state: ENEMY_STATES = ENEMY_STATES.PATROLLING

func _ready():
	set_physics_process(false)
	create_waypoints()
	_player_ref = get_tree().get_first_node_in_group("player")
	call_deferred("set_physics_process", true)

	chase_timer.timeout.connect(_on_chasing_timer_timeout)
	shoot_timer.timeout.connect(_on_shooting_timer_timeout)
	nav_agent.velocity_computed.connect(_on_nav_agent_velocity_computed)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	raycast_to_player()
	update_state()
	update_movement()
	update_navigation()

func update_navigation() -> void:
	if nav_agent.is_navigation_finished() == false:
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		enemy_sprite.look_at(next_path_position)

		var ini_v = global_position.direction_to(next_path_position) * SPEED[_state]
		nav_agent.set_velocity(ini_v)

#make velocity_computed signal on navigation agent node
func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

#Get the field of view angle
func get_fov_angle() -> float:
	var direction = global_position.direction_to(_player_ref.global_position)
	var dot_p = direction.dot(velocity.normalized())
	if dot_p >= -1.0 and dot_p <= 1.0:
		return rad_to_deg(acos(dot_p))
	return 0.0

func player_in_fov() -> bool:
	return get_fov_angle() < FOV[_state]

func create_waypoints() -> void:
	for p in get_node(patrol_points).get_children():
		_waypoints.append(p.global_position)

func navigate_waypoints() -> void:
	if curr_waypoint >= len(_waypoints):
		curr_waypoint = 0
	nav_agent.target_position = _waypoints[curr_waypoint]
	curr_waypoint += 1

func set_navigate_to_player() -> void:
	nav_agent.target_position = _player_ref.global_position

#Rotate the raycast2D to the player
func raycast_to_player() -> void:
	player_detect.look_at(_player_ref.global_position)

func detect_player() -> bool:
	var i = detect_raycast.get_collider()
	if i != null:
		return i.is_in_group("player")
	return false

func can_see_player() -> bool:
	return player_in_fov() and detect_player()

func proccess_patrolling() -> void:
	if nav_agent.is_navigation_finished() == true:
		navigate_waypoints()

func proccess_chasing() -> void:
	set_navigate_to_player()

func proccess_searching() -> void:
	if nav_agent.is_navigation_finished() == true:
		set_state(ENEMY_STATES.PATROLLING)

func update_movement() -> void:
	match _state:
		ENEMY_STATES.PATROLLING:
			proccess_patrolling()
			_play_walk_animation(velocity.normalized())
		ENEMY_STATES.CHASING:
			proccess_chasing()
			_play_run_animation(velocity.normalized())
		ENEMY_STATES.SEARCHING:
			proccess_searching()
			_play_walk_animation(velocity.normalized())

func set_state(new_state = ENEMY_STATES) -> void:
	if new_state == _state:
		return

	if new_state == ENEMY_STATES.CHASING:
		detect_sound.play()
		
	_state = new_state

func update_state() -> void:
	var new_state = _state
	var can_see = can_see_player()

	if can_see == true:
		new_state = ENEMY_STATES.CHASING
	elif can_see == false and new_state == ENEMY_STATES.CHASING:
		new_state = ENEMY_STATES.SEARCHING
		
	set_state(new_state)

func _on_chasing_timer_timeout() -> void:
	if _state != ENEMY_STATES.CHASING:
		return
	shoot_timer.start()


func _on_shooting_timer_timeout() -> void:
	if _state == ENEMY_STATES.CHASING:
		attack_player()

func attack_player() -> void:
	if _player_ref and _player_ref.healths > 0:
		_play_attack_animation()
		_player_ref.healths -= 1
		shoot_sound.play()

func take_damage() -> void:
	enemy_healths -= 1
	if enemy_healths > 0:
		blood_anim.visible = true
		blood_anim.play("Blood2")
	else:
		die_enemy_animation()

func _play_walk_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		enemy_sprite.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_sprite.play("Walk_%s" % _last_side)
	else:
		enemy_sprite.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_sprite.play("Walk_%s" % _last_side)

func _play_run_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		enemy_sprite.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		enemy_sprite.play("Run_%s" % _last_side)
	else:
		enemy_sprite.flip_h = false
		_last_side = "down" if direction.y > 0 else "up"
		enemy_sprite.play("Run_%s" % _last_side)

func _play_attack_animation() -> void:
	enemy_sprite.play("Attack_%s" % _last_side)
	await enemy_sprite.animation_finished()

func die_enemy_animation() -> void:
	blood_anim.visible = true
	blood_anim.play("Blood2")
	await blood_anim.animation_finished()
	enemy_sprite.play("Die_%s" % _last_side)
	await enemy_sprite.animation_finished()

	chase_timer.stop()
	shoot_timer.stop()
	queue_free()
