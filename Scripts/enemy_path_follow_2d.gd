extends PathFollow2D

@export var speed: float = 50
@export var chase_speed:float = 80
@export var chase_range_multiple:float = 5

@onready var enemy = $Enemy

var player = null
var chasing = false
var last_position = Vector2.ZERO

func _ready() :
	player = get_tree().get_nodes_in_group("player")[0]
	last_position = global_position
	
func _process(delta: float) -> void:
	if player:
		if not chasing and enemy.detect_player():
			print("player go to detect range")
			chasing = true
			enemy.increase_raycast(chase_range_multiple)
			player.start_running()

	if player and chasing:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * chase_speed * delta
		enemy._update_animation(direction)
	else :
		progress += speed * delta
		enemy._update_animation(global_position - last_position)
	last_position = global_position
