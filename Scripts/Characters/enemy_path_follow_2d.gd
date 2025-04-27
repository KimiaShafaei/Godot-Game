extends PathFollow2D

@export var speed: float = 50
@export var chase_speed:float = 80
@export var chase_range_multiple:float = 5
@export var shooting_distance:float = 100

@onready var enemy = $"Enemy"
@onready var detect_sound = $"Enemy/understanding"
@onready var chase_timer = $"./Enemy/ChasingTimer"

var player = null
var last_position = Vector2.ZERO

func _ready() :
	player = get_tree().get_first_node_in_group("player")
	last_position = global_position
	chase_timer.timeout.connect(start_shooting)
	
func _process(delta: float) -> void:
	if player:
		if not enemy.chasing and enemy.detect_player():
			start_chasing()
		if enemy.chasing:
			handle_chasing(delta)
		else:
			handle_patrolling(delta)

func handle_chasing(delta: float) -> void:
	var distance_to_player = enemy.global_position.distance_to(player.global_position)
	var direction = (player.global_position - enemy.global_position).normalized()
	var next_position = enemy.global_position + direction * enemy.running_speed * delta
	
	if enemy.tile_map.is_point_walkable(next_position):
		global_position = next_position
		enemy._play_walk_animation(direction)
	
	if distance_to_player <= shooting_distance and enemy.detect_player():
		start_shooting()
	elif distance_to_player > shooting_distance and not enemy.detect_player():
		print("lost player")
		enemy.stop_chasing()

func handle_patrolling(delta: float) -> void:
	enemy.path_follow.progress += enemy.speed * delta
	last_position = enemy.global_position
	var direction = (enemy.global_position - last_position).normalized()

	if direction.length() > 0:
		enemy._play_walk_animation(direction)	

func start_chasing():
	if not enemy.chasing:
		print("start chasing")
		enemy.chasing = true
		enemy.increase_area(enemy.chase_range_multiple)
		if not detect_sound.playing:
			detect_sound.play()
		enemy.state_manager.change_state("ChasingState")
		
func start_shooting():
	if enemy.chasing:
		print("start shooting!")
		enemy.state_manager.change_state("AttackState")
