extends Node

var enemy

func enter():
	enemy.shoot_timer.timeout.connect(_on_shooting_timer_timeout)
	enemy.shoot_timer.start()

func _on_shooting_timer_timeout():
	if enemy._player_ref and enemy._player_ref.healths > 0:
		enemy._play_attack_animation()
		enemy._player_ref.healths -= 1
		enemy.shoot_sound.play()

func exit():
	enemy.shoot_timer.stop()
