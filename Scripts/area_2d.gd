extends Area2D

@export var next_level: String

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var open_box_sound = $"../../open_box"
		var success_sound = $"../../success"
		var box_node = $".."
		
		if open_box_sound and not open_box_sound.playing:
			print("playing open box sound")
			open_box_sound.play()
		
		if box_node:
			print("opening box ...")
			box_node.play("opening_box")
			await box_node.animation_finished
			print("box opened")
			
		if success_sound and not success_sound.playing:
			print("playing success sound")
			success_sound.play()
		
		await get_tree().create_timer(1.5).timeout
		
		if next_level and next_level != "":
			get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")
		else:
			print("No next level")
