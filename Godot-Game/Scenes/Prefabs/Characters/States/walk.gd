extends Node

# Walking state for the enemy character
class_name WalkState

var speed = 100  # Speed of the enemy while walking
var animation_player  # Reference to the AnimationPlayer node

func _ready():
	animation_player = $AnimationPlayer  # Assuming AnimationPlayer is a child node

func enter():
	animation_player.play("Walk")  # Play the walking animation

func exit():
	animation_player.stop()  # Stop the walking animation

func update(delta):
	var direction = Vector2.ZERO  # Initialize direction vector

	# Example input handling for movement
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalize direction and move the enemy
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta  # Move the enemy based on speed and delta time

	# Additional logic for transitioning to other states can be added here
	# For example, checking if the enemy should run or shoot based on conditions
