extends PathFollow2D

@export var speed: float = 50
@export var chase_speed:float = 80
@export var chase_range_multiple:float = 5
@export var shooting_distance:float = 100

@onready var enemy = $"./Enemy"
@onready var detect_sound = $"./Enemy/understanding"
@onready var chase_timer = $"./Enemy/ChasingTimer"

var player = null
var chasing = false
var last_position = Vector2.ZERO

var path = []
var current_index = 0
var tile_map

func _ready() :
	player = get_tree().get_first_node_in_group("player")
	last_position = global_position
	chase_timer.timeout.connect(start_shooting)
	tile_map = get_tree().get_root().get_node("Level_2/TileMapLayer")
	
func _process(delta: float) -> void:
	if player:
		if not chasing and enemy.detect_player():
			start_chasing()
			player.start_running()

	if player and chasing:
		var distance_to_player = global_position.distance_to(player.global_position)
		var direction = (player.global_position - global_position).normalized()	
		var next_position = global_position + direction * chase_speed * delta
		if tile_map.is_point_walkable(next_position):
			global_position = next_position
		else:
			print("enemy block by obstcle")
			
		if distance_to_player <= shooting_distance and enemy.detect_player():
			start_shooting()
		elif distance_to_player > shooting_distance and not enemy.detect_player():
			print("lost player and back to circle")
			stop_chasing()		
	else :
		progress += speed * delta
	last_position = global_position

func start_chasing():
	if not chasing:
		print("start chasing")
		chasing = true
		enemy.increase_raycast(chase_range_multiple)
		if not detect_sound.playing:
			detect_sound.play()
		
		
		path = tile_map.find_path(global_position, player.global_position)
		current_index = 0

func stop_chasing():
	if chasing:
		print("stop chasing")
		chasing = false
		enemy.stop_shooting()
		set_progress_ratio(0.0)

func start_shooting():
	if chasing:
		print("start shooting!")
		enemy.start_shooting()
