extends "res://Scripts/state_machine/state_machine.gd"

@onready var idle = $Idle
@onready var walk = $Walk
@onready var run = $Run
@onready var stagger = $Stagger
@onready var attack = $Attack

func _ready():
	states_map = {
		"idle": idle,
		"walk": walk,
		"run": run,
		"stagger": stagger,
		"attack": attack,
	}


func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	super._change_state(state_name)
