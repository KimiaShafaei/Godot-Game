extends Node2D

signal noise_emitted(noise_position: Vector2)

func emit_noise(noise_position: Vector2) -> void:
	emit_signal("noise_emitted", noise_position)
