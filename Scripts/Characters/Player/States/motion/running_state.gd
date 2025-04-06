extends "res://Scripts/Characters/Player/States/motion/motion.gd"

func enter():
	player.speed = player.running_speed
	player.anim.play("Run_down")

func exit():
	player.speed = 200


func update_animation(direction):
	super(direction)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			player.anim.flip_h = false
			player._last_side = "right"
			player.anim.play("Run_right")
		else:
			player.anim.flip_h = false
			player._last_side = "left"
			player.anim.play("Run_left")
	else:
		if direction.y > 0:
			player.anim.play("Run_down")
			player._last_side = "down"
		else:
			player.anim.play("Run_up")
			player._last_side = "up"
