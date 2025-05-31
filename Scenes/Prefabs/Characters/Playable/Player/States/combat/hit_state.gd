extends Node
var player

func enter():
	player.blood_anim.visible = true
	player.blood_anim.play("Blood2")
	await player.blood_anim.animation_finished
	player.blood_anim.visible = false
	player.state_manager.change_state("IdleState")

func exit():
	pass
