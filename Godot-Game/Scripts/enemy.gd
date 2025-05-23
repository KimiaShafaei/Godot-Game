extends Node

var state_manager

func _ready():
    state_manager = preload("res://Scripts/state_manager.gd").new()
    state_manager.initialize(self)
    state_manager.change_state("idle")

func _process(delta):
    state_manager.update(delta)

func on_player_detected():
    state_manager.change_state("run")

func on_player_out_of_range():
    state_manager.change_state("walk")

func on_health_low():
    state_manager.change_state("die")

func on_idle_timeout():
    state_manager.change_state("idle")