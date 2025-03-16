extends CharacterBody2D

@export var speed = 200
@export var runnig_speed = 400

@onready var anim = $AnimatedSprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var walking_sound = $walking
@onready var background_sound = $"../background"

var _path : Array = []
var _current_index = 0
var _last_side: String= "Idle_down"
var start_chasing = false

func _ready():
	anim.play("Idle_down")
	background_sound.play()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = tile_map.round_local_position(get_global_mouse_position())

		if tile_map.is_point_walkable(click_position):
			_path = tile_map.find_path(global_position, click_position)
			_current_index = 0
				
func _physics_process(_delta):
	if _path.size() > 0 and _current_index < _path.size():
		var target = tile_map.map_to_local(_path[_current_index])
		var direction = (target - global_position).normalized()
		
		velocity = direction * speed
		
		_update_animation(direction)
			
		if global_position.distance_to(target) < 10:
			_current_index += 1
			
		if _current_index >= _path.size():
			tile_map.clear_path()
			_path.clear()
			_current_index = 0
			
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		_play_idle()

func _update_animation(direction):
	if direction.length() > 0:
		if start_chasing:
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					anim.flip_h = false
					_last_side = "right"
					anim.play("Run_right")
				else:
					anim.flip_h = false
					_last_side = "left"
					anim.play("Run_left")
			else:
				if direction.y > 0:
					anim.play("Run_down")
					_last_side = "down"
				else:
					anim.play("Run_up")
					_last_side = "up"
		else:
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					anim.flip_h = false
					_last_side = "right"
					anim.play("Walk_right")
				else:
					anim.flip_h = false
					_last_side = "left"
					anim.play("Walk_left")
			else :
				if direction.y > 0:
					anim.play("Walk_down")
					_last_side = "down"
				else :
					anim.play("Walk_up")
					_last_side = "up"
	
	if direction.length() > 0 and not walking_sound.playing:
		walking_sound.play()
		
func _play_idle():
	if _last_side == "right":
		anim.flip_h = false
		anim.play("Idle_right")
	elif _last_side == "left":
		anim.flip_h = false
		anim.play("Idle_left")
	elif _last_side == "up":
		anim.play("Idle_up")
	else :
		anim.play("Idle_down")
		
	if walking_sound.playing:
		walking_sound.stop()

func start_running():
	print("start running...")
	start_chasing = true
	speed = runnig_speed
	
	
