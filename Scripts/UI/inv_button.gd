extends Button

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_inv_button_pressed() -> void:
	var invs_state = player.state_manager.get_node("InvisibilityState")
	if player.state_manager.current_state.name == "InvisibilityState":
		invs_state.visible()
	else:
		player.state_manager.change_state("InvisibilityState")
		
