extends Node

var enemy

func enter():
	enemy.velocity = Vector2.ZERO
	
	var player = enemy.state_manager.get_attack_target()
	if player and enemy.global_position.distance_to(player.global_position) <= enemy.attack_distance:
		await enemy._play_attack_to_player()
		player.take_damage()

	enemy.state_manager.change_state("WalkingState")

func exit():
	enemy.state_manager.set_attack_target(null)
	
