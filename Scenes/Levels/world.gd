extends Node2D

@onready var music: AudioStreamPlayer2D = $Music

## You should drag and drop player node here
@export var player: Player

## You should drag and drop map node here
@export var map: TileMapLayer

## You should drag and drop enemy nodes here
@export var enemies: Array[Enemy]

func _ready() -> void:
	
	if music and not music.playing:
		music.play()
