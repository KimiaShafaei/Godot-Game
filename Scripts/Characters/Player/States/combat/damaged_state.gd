extends "res://Scripts/state_machine/player_state.gd"

func enter():
	player.healths -= 1
	player.health_bar.value = player.healths
	player.blood_anim.visible = true
	player.blood_anim.play("Blood2")

	if player.healths <= 0:
		player.set_state(load("res://Scripts/Characters/States/dead_state.gd").new(player))
	else:
		await player.blood_anim.animation_finished
		player.set_state(load("res://Scripts/Characters/States/idle_state.gd").new(player))
