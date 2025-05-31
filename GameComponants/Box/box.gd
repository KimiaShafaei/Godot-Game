extends Area2D

@export var next_level: PackedScene

@onready var success_sound: AudioStreamPlayer2D = $success
@onready var open_box_sound: AudioStreamPlayer2D = $open_box
@onready var box: AnimatedSprite2D = $box



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		box.play("opening_box")
		if open_box_sound and not open_box_sound.playing:
			print("playing open box sound")
			open_box_sound.play()
		
		await box.animation_finished
			
		if success_sound and not success_sound.playing:
			print("playing success sound")
			success_sound.play()
		
		await get_tree().create_timer(1.5).timeout
		
		if next_level:
			get_tree().change_scene_to_packed(next_level)
		else:
			print("No next level")
			get_tree().quit()
