extends Area2D

class_name TargetArea

var thing: RigidBody2D = null
var throw_effect_anim: AnimatedSprite2D = null
var thing_anim: AnimatedSprite2D = null
var throw_noises: Node = null

func _process(_delta: float) -> void:
	if thing :
		var dir = (thing.global_position - global_position).normalized()
		global_position += dir

		if global_position.distance_to(thing.global_position) < 3.0:
			throw_effect_anim.global_position = thing.global_position
			throw_effect_anim.play("Throw")
			thing_anim.play()
			throw_noises.emit_noise(global_position)
		thing.queue_free()
		queue_free()
