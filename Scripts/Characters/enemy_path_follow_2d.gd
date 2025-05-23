extends PathFollow2D

@onready var enemy = $"Enemy"
@onready var detect_sound = $"Enemy/understanding"

var player = null
var last_position = Vector2.ZERO

func _ready() :
	player = get_tree().get_first_node_in_group("player")
	last_position = global_position
	
func _process(delta: float) -> void:
	if player:
		if not enemy.chasing and enemy.detect_player():
			enemy.state_manager.change_state("ChasingState")
		if enemy.chasing:
			handle_chasing(delta)
		else:
			handle_patrolling(delta)

func handle_chasing(delta: float) -> void:
	var distance_to_player = enemy.global_position.distance_to(player.global_position)
	var direction = (enemy.player.global_position - enemy.global_position).normalized()
	var next_position = enemy.global_position + direction * enemy.running_speed * delta
	
	if enemy.tile_map.is_point_walkable(next_position):
		global_position = next_position
		enemy._play_run_animation(direction)
	
	if distance_to_player <= enemy.attack_distance and enemy.detect_player():
		enemy.state_manager.change_state("AttackState")

func handle_patrolling(delta: float) -> void:
	last_position = global_position
	progress += enemy.speed * delta
	global_position = enemy.path_follow.global_position
	var direction = (global_position - last_position).normalized()

	if direction.length() > 0:
		enemy._play_walk_animation(direction)	
