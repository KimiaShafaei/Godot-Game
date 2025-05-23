extends Node
var player

func enter():
	player.start_running()
	player.state_manager.change_state("WalkingState")

func exit():
	pass
