extends Node

var enemy

func enter():
	enemy._play_die_animation()
	enemy.velocity = Vector2.ZERO
	enemy.collision_layer = 0
	enemy.collision_mask = 0

func _physics_process(_delta):
	await enemy.enemy_anim.animation_finished
	enemy.queue_free()

func exit():
	pass
