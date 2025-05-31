extends Node2D

@onready var music: AudioStreamPlayer2D = $Music

@export var player: Player
@export var map: TileMapLayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if !map:
		map = $Map
	
	if music and not music.playing:
		music.play()
