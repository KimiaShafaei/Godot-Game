extends Node
var enemy

func enter():
	enemy.blood_anim.visible = true
	enemy.blood_anim.play("Blood")
	await enemy.blood_anim.animation_finished()
	enemy.blood_anim.visible = false

	enemy.die_enemy_animation()
	await enemy.enemy_anim.animation_finished
	enemy.queue_free()

func exit():
	pass
