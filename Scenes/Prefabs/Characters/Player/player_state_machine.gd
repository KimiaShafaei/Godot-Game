extends Node

var player
var current_state: Node = null
var target_enemy = null

func init(p):
	player = p
	for child in get_children():
		child.player = player

func change_state(state_name: String):
	if current_state:
		current_state.exit()
	current_state = get_node(state_name)
	current_state.enter()
