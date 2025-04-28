extends Node

var enemy

func enter():
    enemy.healths -= 1

    enemy.blood_anim.visible = true
    enemy.blood_anim.play("Blood2")
    await enemy.blood_anim.animation_finished
    enemy.blood_anim.visible = false

    if enemy.healths > 0:
        if enemy.player_in_detect_area:
            enemy.state_manager.change_state("ChasingState")
        else:
            enemy.state_manager.change_state("WalkingState")
    else:
        enemy.state_manager.change_state("DieState")

func exit():
    pass