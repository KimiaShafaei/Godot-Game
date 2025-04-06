extends Node

class_name PlayerState

# warning-ignore:unused_signal
signal finished(next_state_name)


var player


func _init(player_instance):
	player = player_instance

func enter():
	pass

func exit():
	pass

func _input(event):
	pass

func _physics_process(delta):
	pass


func update(_delta):
	pass


func _on_animation_finished(_anim_name):
	pass
