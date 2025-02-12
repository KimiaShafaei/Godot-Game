extends CharacterBody2D

@export var speed = 400
@onready var anim = $AnimatedSprite2D

var astar : AStar2D = AStar2D.new()
var path: Array = []
var current_index = 0
var last_side: String= "Idle"

func _ready():
	anim.play("Idle")
	setup_astar()

func setup_astar():
	var tile_size = 16
	var grid_width = 25
	var grid_height = 11
	
	#Add points to the grid
	for x in range(grid_width):
		for y in range(grid_height):
			var point_id = x + y * grid_width
			var pos = Vector2(x * tile_size, y * tile_size)
			astar.add_point(point_id, pos)
			
	#Connect neighbor points
	for x in range(grid_width):
		for y in range(grid_height):
			var point_id = x + y * grid_width
			var neighbors = [
				Vector2(x + 1, y), Vector2(x - 1, y),
				Vector2(x, y + 1), Vector2(x, y - 1)
			]
			for neighbor in neighbors:
				var neighbor_id = int(neighbor.x + neighbor.y * grid_width)
				if astar.has_point(neighbor_id):
					astar.connect_points(point_id, neighbor_id)
					
	
func get_closest_point(pos: Vector2) -> int:
	var closest_id = -1
	var closest_dist = INF
	for id in astar.get_point_ids():
		var distance = pos.distance_to(astar.get_point_position(id))
		if distance < closest_dist:
			closest_dist = distance
			closest_id = id
	return closest_id
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var start_id = get_closest_point(global_position)
		var target_id = get_closest_point(get_global_mouse_position())
		if astar.has_point(start_id) and astar.has_point(target_id):
			path = astar.get_point_path(start_id, target_id)
			current_index = 0
		
func _physics_process(delta):
	if path.size() > 0 and current_index < path.size():
		var target = path[current_index]
		var direction = (target - global_position).normalized()
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
			
		if global_position.distance_to(target) > 5:
			move_and_slide()
		else:
			current_index += 1
	else:
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
