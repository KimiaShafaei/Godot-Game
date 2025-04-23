extends Node

var enemy
var current_state: Node = null
var target_player = null

func init(e):
	print(e)
	enemy = e
	for child in get_children():
		child.enemy = enemy

func change_state(state_name: String):
	if current_state:
		current_state.exit()
	current_state = get_node(state_name)
	current_state.enter()

func set_attack_target(player):
	target_player = player

func get_attack_target():
	return target_player

func _input(event):
	if current_state and current_state.has_method("_input"):
		current_state._input(event)

func _physics_process(delta):
	if current_state and current_state.has_method("_physics_process"):
		current_state._physics_process(delta)
