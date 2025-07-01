extends Control

signal choose_option(thing_name)

func _ready() -> void:
	var bottle_button = $Bottle
	var stone_button = $Stone
	var metal_can_button = $MetalCan

	bottle_button.pressed.connect(_on_bottle_button_pressed)
	stone_button.pressed.connect(_on_stone_button_pressed)
	metal_can_button.pressed.connect(_on_metal_can_button_pressed)
	
func _on_bottle_button_pressed() -> void:
	emit_signal("choose_option", "Bottle")

func _on_stone_button_pressed() -> void:
	emit_signal("choose_option", "Stone")

func _on_metal_can_button_pressed() -> void:
	emit_signal("choose_option", "MetalCan")
