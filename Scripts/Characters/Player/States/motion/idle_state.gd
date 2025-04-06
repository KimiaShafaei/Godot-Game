extends "res://Scripts/Characters/Player/States/motion/motion.gd"

func enter():
	player.anim.play("Idle_down")

func update_animation(direction):
	if player._last_side == "right":
		player.anim.flip_h = false
		player.anim.play("Idle_right")
	elif player._last_side == "left":
		player.anim.flip_h = false
		player.anim.play("Idle_left")
	elif player._last_side == "up":
		player.anim.play("Idle_up")
	else :
		player.anim.play("Idle_down")
		
	if player.walking_sound.playing:
		player.walking_sound.stop()
