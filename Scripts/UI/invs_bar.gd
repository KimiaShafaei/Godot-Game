extends ProgressBar

@onready var invs_bar = $"."

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta):
	var invs_timer = player.invisible_timer
	invs_bar.max_value = invs_timer.wait_time
	invs_bar.value = invs_timer.time_left
