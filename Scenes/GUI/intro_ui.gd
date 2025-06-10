extends Control

@onready var start_button = $CenterContainer/VBoxContainer/HBoxContainer/start
@onready var menu_button = $CenterContainer/VBoxContainer/HBoxContainer/menu
@onready var setting_button = $CenterContainer/VBoxContainer/HBoxContainer2/setting
@onready var quit_button = $CenterContainer/VBoxContainer/HBoxContainer2/quit

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")

func _on_menu_pressed() -> void:
	pass # Replace with function body.

func _on_setting_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
