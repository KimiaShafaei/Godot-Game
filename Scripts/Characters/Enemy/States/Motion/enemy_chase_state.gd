extends Node
var enemy

func enter():
	enemy.detect_sound.play()
	enemy.chase_timer.timeout.connect(_on_chasing_timer_timeout)
	enemy.shoot_timer.timeout.connect(_on_shooting_timer_timeout)
	
func _physics_process(_delta: float) -> void:
	enemy.nav_agent.target_position = enemy._player_ref.global_position
	enemy._play_run_animation(enemy.velocity.normalized())

	if not enemy.can_see_player():
		enemy.state_manager.change_state("SearchingState")

func _on_chasing_timer_timeout() -> void:
	enemy.shoot_timer.start()

func _on_shooting_timer_timeout() -> void:
	enemy.state_manager.change_state("AttackState")


func exit():
	enemy.chase_timer.stop()
	enemy.shoot_timer.stop()
