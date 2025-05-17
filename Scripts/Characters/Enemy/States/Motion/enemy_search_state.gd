extends Node
var enemy

func enter():
	pass

func _physics_process(_delta):
	enemy._play_walk_animation(enemy.velocity.normalized())
	if enemy.nav_agent.is_navigation_finished() == true:
		enemy.state_manager.change_state("PatrollingState")

func exit():
	pass
