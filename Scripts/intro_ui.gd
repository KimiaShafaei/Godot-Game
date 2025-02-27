extends Node2D


@onready var menu_music = $AudioStreamPlayer


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")
	if menu_music.palying:
		menu_music.stop()
	





func _on_menu_pressed() -> void:
	pass # Replace with function body.




func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
