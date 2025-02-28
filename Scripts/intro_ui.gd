extends Node2D



@onready var start_audio = $start_music


func _on_start_pressed() -> void:
	start_audio.stop()
	get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")
	



func _on_menu_pressed() -> void:
	pass # Replace with function body.




func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
