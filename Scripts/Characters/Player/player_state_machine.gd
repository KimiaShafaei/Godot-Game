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

func set_attack_target(enemy):
	target_enemy = enemy

func get_attack_target():
	return target_enemy

func _input(event):
	if current_state and current_state.has_method("_input"):
		current_state._input(event)

func _physics_process(delta):
	if current_state and current_state.has_method("_physics_process"):
		current_state._physics_process(delta)
