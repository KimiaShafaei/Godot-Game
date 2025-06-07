extends Control

signal choose_option(option_name)

func _ready() -> void:
	var bottle_button = $Bottle
	var stone_button = $Stone
	bottle_button.pressed.connect(_on_bottle_button_pressed)
	stone_button.pressed.connect(_on_stone_button_pressed)
	
func _on_bottle_button_pressed() -> void:
	emit_signal("choose_option", "Bottle")

func _on_stone_button_pressed() -> void:
	emit_signal("choose_option", "Stone")
