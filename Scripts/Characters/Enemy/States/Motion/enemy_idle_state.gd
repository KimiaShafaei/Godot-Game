extends Node

var enemy

func enter():
	enemy._play_idle()

func _physics_process(_delta):
	enemy.velocity = Vector2.ZERO

	if enemy.detect_player():
		enemy.state_manager.change_state("ChasingState")
	

func exit():
	pass
