extends CharacterBody2D

class_name Player

var world
var tile_map
var speed

@export var normal_speed = 200
@export var runnig_speed = 400
@export var healths = 3
@export var invisibility_color: Color = Color(1, 1, 1, 0.4)
@export var throw_radius = 100
@export var impulse_mult: float = 20.0
@export var impulse_max: float = 1000.0

@onready var anim = $PlayerAnimatedSprite2D
@onready var walking_sound = $walking
@onready var blood_anim = $Blood
@onready var health_bar = $ProgressBar
@onready var state_manager = $StateManager
@onready var options_UI = get_node_or_null("../OptionsUI")
@onready var throw_noises = get_node_or_null("../ThrowNoises")
@onready var throw_effect_anim = get_node_or_null("../ThrowNoises/ThrowEffectAnimated")
@onready var drag_items = get_node_or_null("../ThrowNoises/DragItems")

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
	if options_UI:
		options_UI.connect("choose_option", Callable(self, "start_dragging"))
#region InputHandling

func _input(event):
	if drag_items.dragging:
		if event is InputEventMouseMotion:
			drag_items.handle_dragging()
		elif event.is_action_released("drag"):
			drag_items.start_releasing_thing()
		return
		
	if event.is_action_pressed("drag") and drag_items.selected_thing_name != "":
		if global_position.distance_to(get_global_mouse_position()) < 32:
			drag_items.global_position = global_position
			drag_items.instantiate_dragged_thing(drag_items.selected_thing_name)
			drag_items.selected_thing_name = ""
		return
		
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
	# if dragging:
	# 	velocity = Vector2.ZERO
	# 	move_and_slide()
	# 	return

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

func start_dragging(thing_name: String) -> void:
	if drag_items:
		drag_items.start_dragging(thing_name)
	await _play_throw_animation()
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
	
	if drag_items:
		drag_items.last_side = _last_side

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

func _play_throw_animation() -> void:
	anim.play("Throw_%s" % _last_side)
	await anim.animation_finished
#endregion

func start_running():
	if not start_chasing:
		start_chasing = true
		speed = runnig_speed
