extends Node
var player

@onready var player_collision = $"../../CollisionShape2D"

func enter():
	player_collision.disabled = true
	player.invisible_sound.play()
	player.invisible_timer.start()
	player.anim.modulate = player.invisibility_color
  	#player.invisible_timer.timeout.connect(_on_invisibility_timer_timeout)

func _on_invisibility_timer_timeout() -> void:
	visible()
	
func visible():
	player.anim.modulate = Color(1, 1, 1, 1)
	player_collision.disabled = false

func exit():
	player.invisible_timer.stop()
	player.invisible_timer.timeout.disconnect(_on_invisibility_timer_timeout)
	player.anim.modulate = Color(1, 1, 1, 1)
	player_collision.disabled = false
