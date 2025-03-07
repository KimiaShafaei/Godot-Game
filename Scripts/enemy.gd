extends CharacterBody2D

@export var radius: float = 50
@export var speed: float = 1.0
@onready var enemy_anim = $AnimatedSprite2D

var angle: float = 0
var center: Vector2 

func _ready():
	center = global_position

func _process(delta):
	angle += speed * delta 
	var new_position = center + Vector2(radius * cos(angle), radius * sin(angle))
	
	var direction = (new_position - global_position).normalized()
	update_animation(direction)
	
	global_position = new_position


func update_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			enemy_anim.play("Walk_right")
		else:
			enemy_anim.play("Walk_left")
	else :
		if direction.y > 0:
			enemy_anim.play("Walk_down")
		else :
			enemy_anim.play("Walk_up")
