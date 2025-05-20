extends Node
var player

func enter():
	player.invisible_sound.play()
	player.anim.madulate = player.invisibility_color
	player.invisible_timer.timeout.connect(_on_invisibility_timer_timeout)
	player.invisible_timer.start()

func _on_invisibility_timer_timeout() -> void:
	player.anim.madulate = Color(1, 1, 1, 1)
	
func exit():
