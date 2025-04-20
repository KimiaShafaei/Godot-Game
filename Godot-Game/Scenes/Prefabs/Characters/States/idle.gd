extends Node

# Idle state for the enemy character
class_name IdleState

var animation_player

func _ready():
	animation_player = $AnimationPlayer

func enter():
	animation_player.play("Idle")

func update(delta):
	# Logic for idle state can be added here
	pass

func exit():
	# Logic for exiting idle state can be added here
	pass
