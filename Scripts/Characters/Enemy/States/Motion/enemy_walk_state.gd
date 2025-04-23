extends Node

var enemy

func enter():
	pass

func _physics_process(delta):
	if enemy.path_follow:
		# Move along the path
		enemy.path_follow.progress += enemy.speed * delta
		enemy.global_position = enemy.path_follow.global_position
		
		# Get the path's curve data
		var path = enemy.path_follow.get_parent() as Path2D
		if path and path.curve:
			# Calculate direction using curve methods
			var current_offset = enemy.path_follow.progress
			var look_ahead = current_offset + 10.0  # Small look-ahead for direction
			
			var current_point = path.curve.sample_baked(current_offset)
			var next_point = path.curve.sample_baked(look_ahead)
			var direction = (next_point - current_point).normalized()
			
			enemy._play_walk_animation(direction)
		
		# State transitions
		if enemy.detect_player():
			enemy.state_manager.change_state("ChasingState")
		
		# Loop handling
		if enemy.path_follow.progress >= path.curve.get_baked_length():
			enemy.path_follow.progress = 0
			
func exit():
	pass
