extends Node

var enemy

var frames_since_start = 0

func enter():
	print("now in patrol state")

func _physics_process(_delta):
	frames_since_start += 1

	if enemy.nav_agent.is_navigation_finished() == true:
		navigate_waypoints()
	enemy._play_walk_animation(enemy.velocity.normalized())
	if frames_since_start > 30 and enemy.can_see_player():
		enemy.state_manager.change_state("ChasingState")

func navigate_waypoints() -> void:
	if enemy.curr_waypoint >= len(enemy._waypoints):
		enemy.curr_waypoint = 0
	enemy.nav_agent.target_position = enemy._waypoints[enemy.curr_waypoint]
	enemy.curr_waypoint += 1

func exit():
	pass
