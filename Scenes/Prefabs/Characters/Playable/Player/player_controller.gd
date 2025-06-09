extends CharacterBody2D

class_name Player

var world
var tile_map
var speed

@export var normal_speed = 200
@export var runnig_speed = 400
@export var healths = 3
@export var invisibility_color: Color = Color(1, 1, 1, 0.4)
@export var throw_radius = 10


@onready var anim = $PlayerAnimatedSprite2D
@onready var walking_sound = $walking
@onready var blood_anim = $Blood
@onready var health_bar = $ProgressBar
@onready var state_manager = $StateManager
@onready var options_UI = $"../OptionsUI"
@onready var throw_noises = $"../ThrowNoises"
@onready var throw_effect_anim = get_node("../ThrowNoises/ThrowEffectAnimated")

var _path: Array = []
var _current_index = 0
var _last_side: String = "down"
var start_chasing = false

func _ready():
	anim.play("Idle_down")
	set_speed(normal_speed)
	blood_anim.visible = false
	world = get_parent()
	tile_map = world.map
	state_manager.init(self)
	options_UI.connect("choose_option", Callable(self, "throw_noise_option"))

#region InputHandling

func _input(event):
	if event.is_action_pressed("set_target"):
		var click_position = tile_map.round_local_position(get_global_mouse_position())
		var target_enemy = get_click_enemy(get_global_mouse_position())

		if target_enemy:
			state_manager.change_state("AttackState")
			reset_path()
			_path = tile_map.find_path(global_position, target_enemy.position)
			
		elif tile_map.is_point_walkable(click_position):
			_path = tile_map.find_path(global_position, click_position)
			
			
			# Check if mouse event is double click
			if event.is_double_click():
				set_speed(runnig_speed)

			_current_index = 0
			state_manager.change_state("WalkingState")

func _physics_process(_delta):
	if _path.is_empty() or _current_index >= _path.size():
		state_manager.change_state("IdleState")
		return

	var target = tile_map.map_to_local(_path[_current_index])
	var direction = (target - global_position).normalized()
	velocity = direction * speed
	_update_animation(direction)

	if global_position.distance_to(target) < 10:
		_current_index += 1

	if _current_index >= _path.size():
		reset_path()
		# Reseting speed
		set_speed(normal_speed)

	var prev_position = global_position
	move_and_slide()
	
	if global_position.distance_to(prev_position) < 1:
		_play_idle()
		
		
func reset_path() -> void:
	tile_map.clear_path()
	_path.clear()
	_current_index = 0
	
func set_speed(value):
	speed = value
#endregion

#region IntractionHandling



func take_damage():
	healths -= 1
	health_bar.value = healths

	blood_anim.visible = true
	blood_anim.play("Blood2")

	if healths > 0:
		state_manager.change_state("HitState")
	else:
		state_manager.change_state("DieState")

func get_click_enemy(click_position):
	for enemy in world.enemies:
		if enemy:
			if enemy.position.distance_to(click_position) < 30:
				return enemy
		
	return

func attack_to_enemy(enemy):
	if global_position.distance_to(enemy.global_position) < 40:
		anim.play("Attack_%s" % _last_side)
		await anim.animation_finished
		enemy.take_damage()

func throw_noise_option(thing_name):
	_play_throw_animation()
	var thing_scene = ""
	var throw_sound: AudioStreamPlayer2D = null
	match thing_name:
		"Bottle":
			thing_scene = "res://Scenes/Prefabs/Throwable_option/Bottle.tscn"
			throw_sound = throw_noises.get_node("BottleThrowSound")
		"Stone":
			thing_scene = "res://Scenes/Prefabs/Throwable_option/Stone.tscn"
			throw_sound = throw_noises.get_node("StoneThrowSound")
		"MetalCan":
			thing_scene = "res://Scenes/Prefabs/Throwable_option/metal_can.tscn"
			throw_sound = throw_noises.get_node("MetalCanThrowSound")
		_:
			return

	if throw_sound and not throw_sound.playing:
		throw_sound.play()
		
	var thing = load(thing_scene).instantiate()
	var radius = Vector2.ZERO
	match _last_side:
		"up": radius = Vector2(0, -throw_radius)
		"down": radius = Vector2(0, throw_radius)
		"left": radius = Vector2(-throw_radius, 0)
		"right": radius = Vector2(throw_radius, 0)
	thing.global_position = global_position + radius

	world.add_child(thing)
	if throw_effect_anim:
		throw_noises.visible = true
		throw_effect_anim.global_position = thing.global_position
		throw_effect_anim.play("Throw")
		await throw_effect_anim.animation_finished
		throw_noises.visible = false

	throw_noises.emit_noise(thing.global_position)
	await get_tree().create_timer(2.0).timeout
	thing.queue_free()
	
#endregion

#region AnimationHandling
func _update_animation(direction):
	if direction.length() > 0:
		if start_chasing or speed == runnig_speed:
			_play_run_animation(direction)
		else:
			_play_walk_animation(direction)

	if direction.length() > 0 and not walking_sound.playing:
		walking_sound.play()

func _play_walk_animation(direction):
	if abs(direction.x) > abs(direction.y):
		anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		anim.play("Walk_%s" % _last_side)
	else:
		_last_side = "down" if direction.y > 0 else "up"
		anim.play("Walk_%s" % _last_side)

func _play_run_animation(direction):
	if abs(direction.x) > abs(direction.y):
		anim.flip_h = false
		_last_side = "right" if direction.x > 0 else "left"
		anim.play("Run_%s" % _last_side)
	else:
		_last_side = "down" if direction.y > 0 else "up"
		anim.play("Run_%s" % _last_side)

func _play_idle():
	anim.flip_h = false
	anim.play("Idle_%s" % _last_side)

	if walking_sound.playing:
		walking_sound.stop()

func _play_throw_animation():
	anim.play("Throw_%s" % _last_side)
	await anim.animation_finished

	if walking_sound.playing:
		walking_sound.stop()
#endregion


func start_running():
	if not start_chasing:
		start_chasing = true
		speed = runnig_speed
