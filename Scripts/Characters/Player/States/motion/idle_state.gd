extends Node
var player

func enter():
	player._play_idle()

func exit():
	pass

func _physics_process(_delta):
	player.velocity = Vector2.ZERO

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
			player.state_manager.change_state("WalkingState")
