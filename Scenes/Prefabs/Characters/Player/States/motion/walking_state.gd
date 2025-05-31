extends Node


var player

func enter():
	pass

func exit():
	pass

func _physics_process(_delta):
	if player._path.is_empty() or player._current_index >= player._path.size():
		player.state_manager.change_state("IdleState")
		return

	var target = player.tile_map.map_to_local(player._path[player._current_index])
	var direction = (target - player.global_position).normalized()
	player.velocity = direction * player.speed
	player._update_animation(direction)

	if player.global_position.distance_to(target) < 10:
		player._current_index += 1

	if player._current_index >= player._path.size():
		player.tile_map.clear_path()
		player._path.clear()
		player._current_index = 0

	var prev_position = player.global_position
	player.move_and_slide()

	if player.global_position.distance_to(prev_position) < 1:
		player._play_idle()
