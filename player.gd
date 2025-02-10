extends CharacterBody2D

@export var speed = 400
@onready var anim = $AnimatedSprite2D
var target : Vector2
var move: bool= false
var last_side: String= "Idle"

func _ready():
	target= global_position
	anim.play("Idle")
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		target = get_global_mouse_position()
		move= true

func _physics_process(delta):
	if move:
		var direction = global_position.direction_to(target)
		velocity = direction * speed
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0 :
				anim.flip_h = false
				last_side = "right"
			else :
				anim.flip_h = true
				last_side = "left"
			anim.play("Walk_side")
		else :
			if direction.y > 0:
				anim.play("Walk_down")
				last_side = "down"
			else:
				anim.play("Walk_up")
				last_side = "up"
			
			
		if global_position.distance_to(target) > 10:
			move_and_slide()
		else:
			move = false
			velocity = Vector2.ZERO
			anim.play("Idle")
			play_idle()

func play_idle():
	if last_side == "right":
		anim.flip_h = false
		anim.play("Idle_side")
	elif last_side == "left":
		anim.flip_h = true
		anim.play("Idle_side")
	elif last_side == "up":
		anim.play("Idle_up")
	else :
		anim.play("Idle")
