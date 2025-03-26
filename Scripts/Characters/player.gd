extends CharacterBody2D

@export var speed = 200
@export var runnig_speed = 400
@export var healths = 3

@onready var anim = $AnimatedSprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var walking_sound = $walking
@onready var background_sound = $"../background"
@onready var blood_anim = $Blood
@onready var health_bar = $"../ProgressBar/HealthBar"

var _path : Array = []
var _current_index = 0
var _last_side: String= "Idle_down"
var start_chasing = false

func _ready():
	anim.play("Idle_down")
	background_sound.play()
	blood_anim.visible = false
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var click_position = tile_map.round_local_position(get_global_mouse_position())
		
		var click_enemy = get_click_enemy(click_position)
		if click_enemy:
			attack_to_enemy(click_enemy)
			return
			
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
		
		var prev_position = global_position
		move_and_slide()
		if global_position.distance_to(prev_position) < 1:
			_play_idle()
			
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
	if not start_chasing:
		print("start running...")
		start_chasing = true
		speed = runnig_speed

func get_click_enemy(click_position):
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.global_position.distance_to(click_position) < 30:
			return enemy
	return null
	
func attack_to_enemy(enemy):
	if global_position.distance_to(enemy.global_position) < 40:
		print("player attacks to enemy")
		anim.play("Attack_" + _last_side)
		print("play attack to enemy")
		await anim.animation_finished
		enemy.die_enemy()
	
func take_damage():
	healths -= 1
	print("decrease 1 helth", healths)
	health_bar.value = healths
	
	blood_anim.visible = true
	blood_anim.play("Blood2")
	print("play blood animation for shot player" )
	
	if healths > 0:
		print("play hit player animation")
	else:
		print("play die player animation")
		die_player()

func die_player():
	blood_anim.visible = true
	blood_anim.play("Blood")
	print("play blood animation dor die player")
	await blood_anim.animation_finished
	blood_anim.visible = false
	
	if velocity.y >0:
		anim.play("Death_up")
	elif velocity.y < 0:
		anim.play("Death_down")
	elif velocity.x > 0:
		anim.play("Death_right")
	elif velocity.x < 0:
		anim.play("Death_left")
		
	await anim.animation_finished
	print("Game over so play this level again")
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")
