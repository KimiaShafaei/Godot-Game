extends Node

var enemy

func enter():
	enemy.start_running()

func _physics_process(delta):
	if enemy.detect_player():
		var direction = (enemy.player.global_position - enemy.global_position).normalized()
		enemy.global_position += direction * enemy.running_speed * delta
		enemy._play_run_animation(direction)
	else:
		enemy.state_manager.change_state("WalkingState")

func exit():
	pass
	
