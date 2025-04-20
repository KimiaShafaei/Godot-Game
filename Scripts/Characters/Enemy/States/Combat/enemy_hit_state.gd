extends Node

var enemy

func enter():
    enemy.blood_anim.visible = true
    enemy.blood_anim.play("Blood2")
    await enemy.blood_anim.animation_finished
    enemy.blood_anim.visible = false
    enemy.state_manager.change_state("WalkingState")

func exit():
    pass