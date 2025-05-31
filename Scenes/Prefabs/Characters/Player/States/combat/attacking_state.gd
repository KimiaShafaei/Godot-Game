extends Node
var player

func enter():
	var enemy = player.state_manager.get_attack_target()
	if enemy and player.global_position.distance_to(enemy.global_position) < 40:
		player.anim.play("Attack_%s" % player._last_side)
		await player.anim.animation_finished
		enemy.die_enemy()
	player.state_manager.change_state("IdleState")

func exit():
	player.state_manager.set_attack_target(null)
