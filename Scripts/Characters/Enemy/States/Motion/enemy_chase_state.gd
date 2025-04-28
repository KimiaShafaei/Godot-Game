extends Node

var enemy
var last_position = Vector2.ZERO
var progress = 0.0

@onready var detect_sound = $"../../understanding"

func enter():
	if not detect_sound.playing:
		detect_sound.play()
	start_running()
	enemy.detect_area.scale *= enemy.chase_range_multiple
	enemy.chase_timer.start()
	_await_chase_timer()

func _physics_process(delta: float) -> void:
	if enemy.player and enemy.chasing:
		var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
		var direction = (enemy.player.global_position - enemy.global_position).normalized()	
		var next_position = enemy.global_position + direction * enemy.running_speed * delta

		if enemy.tile_map.is_point_walkable(next_position):
			enemy.global_position = next_position
			enemy._play_run_animation(direction)
			
		if distance_to_player <= enemy.attack_distance and enemy.detect_player():
			enemy.state_manager.change_state("HitState")
		elif distance_to_player > enemy.attack_distance and not enemy.detect_player():
			stop_chasing()

func _await_chase_timer():
	await enemy.chase_timer.timeout
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) <= enemy.attack_distance:
		enemy.state_manager.change_state("AttackState")
	else:
		enemy.chase_timer.start()
		_await_chase_timer()

func start_running():
	if not enemy.chasing:
		enemy.chasing = true
		enemy.speed = enemy.running_speed

func stop_chasing():
	print("stop chasing")
	enemy.chasing = false
	enemy.reset_area()
	enemy.state_manager.change_state("WalkingState")

func exit():
	enemy.detect_area.scale = enemy.default_detect_area
	enemy.chase_timer.stop()
