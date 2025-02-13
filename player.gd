extends CharacterBody2D

@export var speed = 400
@onready var anim = $AnimatedSprite2D
@onready var tile_map = $"../TileMapLayer"

var _path : Array = []
var _current_index = 0
var _last_side: String= "Idle"

func _ready():
	anim.play("Idle")
	
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = tile_map.round_local_position(get_global_mouse_position())
		print("Click Position:", click_position)

		if tile_map.is_point_walkable(click_position):
			_path = tile_map.find_path(global_position, click_position)
			print("Generated Path:", _path)
			
			_current_index = 0
			if _path.size() > 1:
				print("Path found", _path)
			else:
				print("No path found")
				
func _physics_process(delta):
	if _path.size() > 0 and _current_index < _path.size():
		var target = tile_map.map_to_local(_path[_current_index])
		var direction = (target - global_position).normalized()
		print("Target:", target, "Direction", direction)
		velocity = direction * speed
		
		_update_animation(direction)
			
		if global_position.distance_to(target) < 4:
			print("Reached target")
			_current_index += 1
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		anim.play("Idle")

func _update_animation(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.flip_h = false
			_last_side = "right"
		else:
			anim.flip_h = true
			_last_side = "left"
		anim.play("Walk_side")
	else :
		if direction.y > 0:
			anim.play("Walk_down")
			_last_side = "down"
		else :
			anim.play("Idle_up")
			_last_side = "up"

func _play_idle():
	if _last_side == "right":
		anim.flip_h = false
		anim.play("Idle_side")
	elif _last_side == "left":
		anim.flip_h = true
		anim.play("Idle_side")
	elif _last_side == "up":
		anim.play("Idle_up")
	else :
		anim.play("Idle")
