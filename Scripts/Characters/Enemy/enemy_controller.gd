extends CharacterBody2D

@export var FOV: Dictionary = {
	"PatrollingState": 60.0,
	"ChasingState": 120.0,
	"SearchingState": 100.0
}

@export var SPEED: Dictionary = {
	"PatrollingState": 60.0,
	"ChasingState": 100.0,
	"SearchingState": 80.0
}

@export var patrol_points: NodePath
@export var enemy_healths: int = 1

@onready var enemy_sprite: AnimatedSprite2D = $EnemyAnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player_detect = $PlayerDetect
@onready var detect_raycast = $PlayerDetect/DetectRayCast2D
@onready var detect_sound = $understanding
@onready var chase_timer = $ChasingTimer
@onready var shoot_timer = $ShootingTimer
@onready var shoot_sound = $ShootingSound
@onready var blood_anim = $BloodAnimatedSprite
@onready var state_manager = $StateManager

var _last_side: String = "down"
var _waypoints: Array = []
var curr_waypoint: int = 0
var _player_ref: Player

func _ready():
	set_physics_process(false)
	create_waypoints()
	#nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	_player_ref = get_tree().get_first_node_in_group("player")
	call_deferred("set_physics_process", true)

	state_manager.init(self)
	state_manager.change_state("PatrollingState")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("set_target"):
		nav_agent.target_position = get_global_mouse_position()
	raycast_to_player()
	update_navigation()

func update_navigation() -> void:
	if nav_agent.is_navigation_finished() == false:
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		# enemy_sprite.look_at(next_path_position)

		var direction = global_position.direction_to(next_path_position)
		var speed = SPEED[state_manager.current_state.name]
		print("Current state name: ", state_manager.current_state.name)
		print(speed)
		velocity  = direction * speed
	
	move_and_slide()
	
#make velocity_computed signal on navigation agent node
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
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
	return get_fov_angle() < FOV[state_manager.current_state.name]

func create_waypoints() -> void:
	for p in get_node(patrol_points).get_children():
		print(p.global_position)
		_waypoints.append(p.global_position)
	print("WAY POINTS: ", _waypoints)

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

func _play_idle_animation(_direction: Vector2) -> void:
	enemy_sprite.flip_h = false
	enemy_sprite.play("Idle_%s" % _last_side)

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
	await enemy_sprite.animation_finished

func die_enemy_animation() -> void:
	blood_anim.visible = true
	blood_anim.play("Blood2")
	await blood_anim.animation_finished
	enemy_sprite.play("Die_%s" % _last_side)
	await enemy_sprite.animation_finished
