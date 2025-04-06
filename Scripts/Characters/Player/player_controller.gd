extends CharacterBody2D

@export var speed = 200
@export var running_speed = 400
@export var healths = 3

@onready var anim = $AnimatedSprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var walking_sound = $walking
@onready var health_bar = $"../ProgressBar/HealthBar"
@onready var blood_anim = $Blood

var current_state
var _path = []  # Array to store the path
var _current_index = 0  # Index to track the current point in the path
var start_chasing = false
var _last_side: String= "Idle_down"


	
func take_damage(attacker, amount, effect = null):
	if is_ancestor_of(attacker):
		return
		
	$Health.take_damage(amount, effect)

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value

