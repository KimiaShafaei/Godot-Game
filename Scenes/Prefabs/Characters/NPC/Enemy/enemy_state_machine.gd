extends Node

var enemy
var current_state: Node = null
var target_player = null

func init(e):
	enemy = e
	for child in get_children():
		child.enemy = enemy

func change_state(state_name: String):
	#print("Changing state to: ", state_name)
	if current_state:
		current_state.exit()
	current_state = get_node(state_name)
	current_state.enter()

func set_attack_target(player):
	target_player = player

func get_attack_target():
	return target_player
	
func get_current_state_name():
	return current_state.name
