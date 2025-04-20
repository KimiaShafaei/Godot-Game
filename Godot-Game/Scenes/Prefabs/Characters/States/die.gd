extends "State"

# This script defines the behavior for the dying state of the enemy.
# It will manage the death animation and any cleanup needed.

var death_animation : AnimationPlayer

func _ready():
	death_animation = $AnimationPlayer

func enter():
	# Play the death animation
	death_animation.play("Death")

func update(delta):
	# Optionally, you can add logic here to handle what happens during the dying state
	pass

func exit():
	# Cleanup or reset any necessary variables or states
	queue_free()  # Remove the enemy from the scene after dying
