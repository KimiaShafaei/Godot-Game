extends Node
var player

func enter():
	player.blood_anim.visible = true
	player.blood_anim.play("Blood")
	await player.blood_anim.animation_finished
	player.blood_anim.visible = false

	var dir = player.velocity
	if dir.y > 0:
		player.anim.play("Death_up")
	elif dir.y < 0:
		player.anim.play("Death_down")
	elif dir.x > 0:
		player.anim.play("Death_right")
	else:
		player.anim.play("Death_left")

	await player.anim.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")

func exit():
	pass
