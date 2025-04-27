extends Node

var enemy
var last_position = Vector2.ZERO
var progress = 0.0

@onready var detect_sound = $"../../understanding"

func enter():
	if not detect_sound.playing:
		detect_sound.play()
	enemy.start_running()
	enemy.increase_area(enemy.chase_range_multiple)
	enemy.chase_timer.start()

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
			enemy.stop_chasing()

func exit():
	enemy.reset_area()
	enemy.chase_timer.stop()
