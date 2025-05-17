extends Node

var enemy

func enter():
	pass

func _physics_process(_delta):
	if enemy.nav_agent.is_navigation_finished() == true:
		navigate_waypoints()
	enemy._play_walk_animation(enemy.velocity.normalized())
	if enemy.can_see_player():
		enemy.state_manager.change_state("ChasingState")

func navigate_waypoints() -> void:
	if enemy.curr_waypoint >= len(enemy._waypoints):
		enemy.curr_waypoint = 0
	enemy.nav_agent.target_position = enemy._waypoints[enemy.curr_waypoint]
	enemy.curr_waypoint += 1

func exit():
	pass
