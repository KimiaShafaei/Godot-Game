extends CharacterBody2D

@export var radius: float = 50
@export var speed: float = 50.0
@export var chase_speed: float = 80.0
@export var detect_range: float = 100.0

@onready var enemy_anim = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var detect_sound = $"../understanding"
var angle: float = 0
var center: Vector2
var player: CharacterBody2D = null
var chasing: bool = false

func _ready():
	center = global_position
	raycast.enabled = true
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	if player and global_position.distance_to(player.global_position) <= detect_range:
		var dir_to_player = (player.global_position - global_position).normalized()
		raycast.target_position = dir_to_player * detect_range
		raycast.force_raycast_update()
		
		if raycast.is_colliding() and raycast.get_collider() == player:
			chasing = true
			detect_sound.play()
			player.start_running()
	
	if chasing:
		chase_player(delta)
		print("chasing player")
		
		if global_position.distance_to(player.global_position) < 10:
			chasing = false
			print("start killing")
	else :
		walk_circle_path(delta)	

func walk_circle_path(delta):
	angle += speed * delta / radius
	var new_position = center + Vector2(radius * cos(angle), radius * sin(angle))
	move_enemy(new_position)
	
func chase_player(delta):
	var direction = (player.global_position - global_position).normalized()
	move_enemy(global_position + direction * chase_speed * delta)

func move_enemy(new_pos):
	var direction = (new_pos - global_position).normalized()
	update_animation(direction)
	global_position = new_pos

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
