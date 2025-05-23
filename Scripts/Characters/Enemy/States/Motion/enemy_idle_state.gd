extends Node

var enemy

func enter():
	enemy._play_idle_animation(enemy.velocity.normalized())

func _physics_process(_delta):
	if enemy.can_see_player():
		enemy.state_manager.change_state("ChasingState")
	
func exit():
	pass
