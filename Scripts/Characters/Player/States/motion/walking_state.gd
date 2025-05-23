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

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = player.tile_map.round_local_position(player.get_global_mouse_position())
		var click_enemy = player.get_click_enemy(click_position)
		if click_enemy:
			player.state_manager.set_attack_target(click_enemy)
			player.state_manager.change_state("AttackState")
		elif player.tile_map.is_point_walkable(click_position):
			player._path = player.tile_map.find_path(player.global_position, click_position)
			player._current_index = 0
