extends "res://Scripts/Characters/Player/States/motion/motion.gd"

func enter():
	# Play the walking animation (direction will be updated in _physics_process)
	player.update_animation()

func update_animation(direction):
	super(direction)
	if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
					player.anim.flip_h = false
					player._last_side = "right"
					player.anim.play("Walk_right")
			else:
					player.anim.flip_h = false
					player._last_side = "left"
					player.anim.play("Walk_left")
	else :
			if direction.y > 0:
					player.anim.play("Walk_down")
					player._last_side = "down"
			else :
					player.anim.play("Walk_up")
					player._last_side = "up"
