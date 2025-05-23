extends Node

class_name EnemyState

signal finished(next_state_name)

var enemy

func _init(enemy_instance):
    enemy = enemy_instance

func enter():
    pass

func exit():
    pass

func _input(event):
    pass

func _physics_process(delta):
    pass

func update(_delta):
    pass

func _on_animation_finished(_anim_name):
    pass