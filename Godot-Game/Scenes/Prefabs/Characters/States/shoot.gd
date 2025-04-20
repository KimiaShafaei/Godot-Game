extends Node

# This script defines the behavior for the shooting state of the enemy.
# It will handle shooting mechanics and animations.

var shoot_timer: Timer
var shoot_animation: AnimationPlayer

func _ready():
    shoot_timer = Timer.new()
    shoot_timer.wait_time = 1.0  # Adjust the shooting interval as needed
    shoot_timer.connect("timeout", self, "_on_shoot_timeout")
    add_child(shoot_timer)
    shoot_animation = $AnimationPlayer  # Assuming there's an AnimationPlayer node

func enter():
    shoot_timer.start()
    shoot_animation.play("Shoot")  # Play the shooting animation

func _on_shoot_timeout():
    shoot()  # Call the shooting function

func shoot():
    # Implement shooting logic here, e.g., instantiating a bullet
    print("Shooting!")  # Placeholder for shooting action

func exit():
    shoot_timer.stop()
    shoot_animation.stop()  # Stop the shooting animation if needed