extends Node

var enemy

func enter():
	if not enemy.understanding_sound.playing:
		enemy.understanding_sound.play()
		
	enemy.start_running()
	enemy.increase_raycast(enemy.chase_range_multiple)

	enemy.chase_timer.start()

func _physics_process(delta):
	if enemy.chase_timer.time_left > 0:
		if enemy.detect_player():
			var direction = (enemy.player.global_position - enemy.global_position).normalized()
			enemy.global_position += direction * enemy.running_speed * delta
			enemy._play_run_animation(direction)
	else:
		var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
		if distance_to_player <= enemy.attack_distance:
			enemy.state_manager.change_state("HitState")
		else:
			enemy.state_manager.change_state("WalkingState")

func exit():
	enemy.reset_raycast()
	enemy.chase_timer.stop()
