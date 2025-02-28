extends CharacterBody2D

@export var speed = 200
@onready var anim = $AnimatedSprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var walking_sound = $walking
@onready var success_sound = $"../success"
@onready var open_box_sound = $"../open_box"
@onready var background_sound = $"../background"

var _path : Array = []
var _current_index = 0
var _last_side: String= "Idle"
var end_point: Vector2

func _ready():
	anim.play("Idle")
	end_point = tile_map.map_to_local(Vector2i(12, 1))
	background_sound.play()
	
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
			
		if global_position.distance_to(target) < 10:
			print("Reached target")
			_current_index += 1
			
		if _current_index >= _path.size():
			print("reach final point")
			tile_map.clear_path()
			_path.clear()
			_current_index = 0
			
		if global_position.distance_to(end_point) < 10:
			print("Reached to endpoind. The game is over!")
			if open_box_sound and not open_box_sound.playing:
				open_box_sound.play()
			open_box()
			success_sound.play()
			await get_tree().create_timer(1.0).timeout
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		_play_idle()

func _update_animation(direction):
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

func open_box():
	var box_node = get_node("../box")
	if box_node:
		print("opening box")
		box_node.play("opening_box")
		await box_node.animation_finished
		print("box opened")
		background_sound.stop()
		get_tree().quit()
	else:
		print("error for opening box")

func show_game_over():
	var dialog = $FinishGame
	print("show finish the game")
	dialog.dialog_text = "This level of the game is over."
	dialog.window_title = "Game finished"
	dialog.ok_button_text = "OK"
	dialog.popup_centered()
	
	await dialog.confirmed
	get_tree().quit()
