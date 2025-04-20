extends Node

var enemy

func enter():
	enemy._play_walk_animation(Vector2.ZERO)

func _physics_process(_delta):
	if enemy.path_follow:
		enemy.path_follow.offset += enemy.speed * _delta
		enemy.global_position = enemy.path_follow.global_position
		var direction = enemy.path_follow.get_offset_direction()
		enemy._play_walk_animation(direction)

	if enemy.detect_player():
		enemy.state_manager.change_state("ChasingState")
	
	if enemy.path_follow.offset >= enemy.path_follow.path_length:
		enemy.path_follow.offset = 0

func exit():
	pass
