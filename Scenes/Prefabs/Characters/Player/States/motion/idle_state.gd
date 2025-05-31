extends Node
var player

func enter():
	player._play_idle()

func exit():
	pass

func _physics_process(_delta):
	player.velocity = Vector2.ZERO
