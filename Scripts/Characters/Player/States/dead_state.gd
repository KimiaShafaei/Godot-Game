extends "res://Scripts/state_machine/player_state.gd"

func enter():
	player.anim.play("Death_" + player._last_side)
	await player.anim.animation_finished
