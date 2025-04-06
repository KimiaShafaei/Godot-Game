extends "res://Scripts/state_machine/player_state.gd"


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = player.tile_map.round_local_position(player.get_global_mouse_position())
		if player.tile_map.is_point_walkable(click_position):
			player.set_state(load("res://Scripts/Characters/States/walking_state.gd").new(player))
			player._path = player.tile_map.find_path(player.global_position, click_position)
			player._current_index = 0

func _physics_process(delta):
	if player._path.size() > 0 and player._current_index < player._path.size():
		var target = player.tile_map.map_to_local(player._path[player._current_index])
		var direction = (target - player.global_position).normalized()
		player.velocity = direction * player.speed
		player.move_and_slide()

		# Update animation based on movement direction
		player.update_animation(direction)

		if player.global_position.distance_to(target) < 10:
			player._current_index += 1

		if player._current_index >= player._path.size():
			player._path.clear()
			player.set_state(load("res://Scripts/Characters/States/idle_state.gd").new(player))
	else:
		player.velocity = Vector2.ZERO
		player.set_state(load("res://Scripts/Characters/States/idle_state.gd").new(player))


func update_animation(direction):
	if direction.length() > 0:
		if player.start_chasing:
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					player.anim.flip_h = false
					player._last_side = "right"
					player.anim.play("Run_right")
				else:
					player.anim.flip_h = false
					player._last_side = "left"
					player.anim.play("Run_left")
			else:
				if direction.y > 0:
					player.anim.play("Run_down")
					player._last_side = "down"
				else:
					player.anim.play("Run_up")
					player._last_side = "up"
		
	
	if direction.length() > 0 and not player.walking_sound.playing:
		player.walking_sound.play()
