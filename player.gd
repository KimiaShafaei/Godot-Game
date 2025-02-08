extends CharacterBody2D

@export var speed = 400
var target : Vector2
var move: bool= false

func _ready():
	target= global_position
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		target = get_global_mouse_position()
		move= true

func _physics_process(delta):
	if move:
		velocity = global_position.direction_to(target) * speed
		if global_position.distance_to(target) > 10:
			move_and_slide()
		else:
			move = false
			velocity = Vector2.ZERO
