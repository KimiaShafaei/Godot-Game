extends Node2D

class_name DragItems

@export var impulse_mult: float = 20.0
@export var impulse_max: float = 1000.0

var player
var world
var last_side

var throw_sound: AudioStreamPlayer2D = null
var thing_anim: AnimatedSprite2D = null
var selected_thing_name: String = ""
var drag_lim_max: Vector2
var drag_lim_min: Vector2
var dragging: bool = false
var curr_thing: RigidBody2D = null
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _start: Vector2 = Vector2.ZERO
var _thing_scale_x: float = 0.0
var target_area: Area2D = null

func _ready():
	world = get_parent().get_parent()
	player = world.get_node_or_null("Player")
	last_side = player._last_side

# func _input(event):
# 	if dragging:
# 		if event is InputEventMouseMotion:
# 			handle_dragging()
# 		elif event.is_action_released("drag"):
# 			start_releasing_thing()
# 		return

# 	if event.is_action_pressed("drag") and selected_thing_name != "":
# 		if global_position.distance_to(get_global_mouse_position()) < 32:
# 			instantiate_dragged_thing(selected_thing_name)
# 			selected_thing_name = ""
# 		return

#region Dragging item
func start_dragging(thing_name: String) -> void:
	selected_thing_name = thing_name

func instantiate_dragged_thing(thing_name: String) -> void:
	# Load and instantiate the thing
	var thing_scene_path = "res://Scenes/Prefabs/Throwable_option/%s.tscn" % thing_name
	var thing_scene = load(thing_scene_path)
	curr_thing = thing_scene.instantiate()
	curr_thing.global_position = global_position
	curr_thing.visible = true
	curr_thing.freeze = true

	world.add_child(curr_thing)
	
	#Load and instantiate the target area
	var target_scene = load("res://Scenes/Prefabs/Throwable_option/target_area.tscn")
	target_area = target_scene.instantiate()

	throw_sound = curr_thing.get_node_or_null("%sThrowSound" % thing_name)
	thing_anim = curr_thing.get_node_or_null("AnimatedSprite2D")

	update_drag_limits()

	_start = global_position
	_drag_start = get_global_mouse_position()
	_thing_scale_x = curr_thing.scale.x
	dragging = true

#for setting drag limits based on the last side
func update_drag_limits():
	match last_side:
		"right":
			drag_lim_max = Vector2(0, 60)
			drag_lim_min = Vector2(-60, -60)
		"left":
			drag_lim_max = Vector2(60, 60)
			drag_lim_min = Vector2(0, -60)
		"down":
			drag_lim_max = Vector2(60, 0)
			drag_lim_min = Vector2(-60, -60)
		"up":
			drag_lim_max = Vector2(60, 60)
			drag_lim_min = Vector2(-60, 0)

func handle_dragging() -> void:
	if not dragging or curr_thing == null:
		return
	var new_drag_vector: Vector2 = get_global_mouse_position() - _drag_start
	new_drag_vector = new_drag_vector.clamp(drag_lim_min, drag_lim_max)
	_dragged_vector = new_drag_vector
	curr_thing.position = _start + _dragged_vector
	update_thing_scale()

func update_thing_scale() -> void:
	var impulse_len: float = calculate_impulse_().length()
	var perc: float = clamp(impulse_len / impulse_max, 0.0, 1.0)
	curr_thing.scale.x = lerp(_thing_scale_x, _thing_scale_x * 2, perc)
	curr_thing.rotation = (_start - curr_thing.position).angle()
#endregion

#region Releasing item
func start_releasing_thing() -> void:
	if not dragging or curr_thing == null:
		return
	dragging = false
	curr_thing.freeze = false
	curr_thing.apply_central_impulse(calculate_impulse_())
	
	target_area.global_position = curr_thing.global_position - (_dragged_vector * 4.0)

	# target_area.thing = curr_thing
	target_area.thing_anim = thing_anim
	target_area.throw_effect_anim = world.get_node_or_null("ThrowNoises/ThrowEffectAnimated")

	world.add_child(target_area)

	if throw_sound and not throw_sound.playing:
		throw_sound.play()

func calculate_impulse_() -> Vector2:
	return _dragged_vector * -impulse_mult
#endregion
