extends "State"

var speed = 200

func enter():
    # Logic to execute when entering the run state
    $AnimationPlayer.play("Run")

func update(delta):
    # Logic to execute every frame while in the run state
    var direction = Vector2.ZERO
    if Input.is_action_pressed("ui_right"):
        direction.x += 1
    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
    if Input.is_action_pressed("ui_down"):
        direction.y += 1
    if Input.is_action_pressed("ui_up"):
        direction.y -= 1

    direction = direction.normalized()
    position += direction * speed * delta

func exit():
    # Logic to execute when exiting the run state
    $AnimationPlayer.stop()