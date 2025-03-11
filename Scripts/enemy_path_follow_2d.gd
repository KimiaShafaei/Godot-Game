extends PathFollow2D

@export var speed: float = 50
@export var chase_speed:float = 80
@export var detect_range: float = 100
@export var chase_range_multiple:float = 5
@onready var enemy_anim = $Enemy/AnimatedSprite2D
@onready var raycast = $Enemy/RayCast2D

var player = null
var chasing = false
var last_position = Vector2.ZERO

func _ready() :
	player = get_tree().get_nodes_in_group("player")[0]
	last_position = global_position
	
func _process(delta: float) -> void:
	if player and player.position.distance_to(global_position) < detect_range:
		if not chasing:
			chasing = true
			raycast.target_position *= chase_range_multiple
			player.start_running()
	else :
		chasing = false
	
	if player and chasing:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * chase_speed * delta
		_update_animation(direction)
	else :
		progress += speed * delta
		_update_animation(global_position - last_position)
	last_position = global_position

func _update_animation(direction:  Vector2):
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
	
