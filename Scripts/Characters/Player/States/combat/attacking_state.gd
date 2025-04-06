extends "res://Scripts/state_machine/player_state.gd"

func enter():
	player.anim.play("Attack_" + player._last_side)
	await player.anim.animation_finished
	player.set_state(load("res://Scripts/Characters/States/idle_state.gd").new(player))
