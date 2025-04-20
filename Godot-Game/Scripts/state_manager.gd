extends Node

class_name StateManager

var current_state: Node = null
var states: Dictionary = {}

func _ready():
	states["walk"] = preload("res://Scenes/Prefabs/Characters/States/walk.gd").new()
	states["run"] = preload("res://Scenes/Prefabs/Characters/States/run.gd").new()
	states["shoot"] = preload("res://Scenes/Prefabs/Characters/States/shoot.gd").new()
	states["die"] = preload("res://Scenes/Prefabs/Characters/States/die.gd").new()
	states["idle"] = preload("res://Scenes/Prefabs/Characters/States/idle.gd").new()
	
	set_state("idle")

func set_state(state_name: String):
	if current_state:
		current_state.exit()
		current_state.queue_free()
	
	current_state = states[state_name]
	add_child(current_state)
	current_state.enter()

func _process(delta: float):
	if current_state:
		current_state.update(delta)
