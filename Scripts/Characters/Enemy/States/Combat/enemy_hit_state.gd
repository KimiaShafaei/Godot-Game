extends Node
var enemy

func enter():
    enemy.enemy_healths -= 1
    if enemy.enemy_healths > 0:
        enemy.blood_anim.visible = true
        enemy.blood_anim.play("Blood2")
        await enemy.blood_anim.animation_finished()
        enemy.state_manager.change_state("PatrollingState")
    else:
        enemy.state_manager.change_state("DieState")
        
func exit():
    pass