extends Node

var enemy

func enter():
	print("Enemy Attack State")	
	var player = enemy.player
	if player and enemy.global_position.distance_to(player.global_position) <= enemy.attack_distance:
		await enemy._play_attack_to_player()
		player.take_damage()
	else:
		enemy.state_manager.change_state("ChasingState")

func _physics_process(delta):
	var player = enemy.player
	if not enemy.detect_player():
		enemy.state_manager.change_state("WalkingState")
	elif player and enemy.global_position.distance_to(player.global_position) > enemy.attack_distance:
		enemy.state_manager.change_state("ChasingState")

func exit():
	enemy.state_manager.set_attack_target(null)
	
