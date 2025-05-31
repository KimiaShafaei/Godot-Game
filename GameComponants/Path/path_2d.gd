extends Path2D

var parent
var last_point
var idx
func _ready() -> void:
	parent = get_parent()
	last_point = curve.point_count
	idx = 0
	
func _physics_process(_delta: float) -> void:
	
	if parent.state_manager.get_current_state_name() == "PatrollingState":
		if parent._current_index == 0:
			idx += 1
			parent.go_to_position(curve.get_point_position(idx))
			if idx == last_point - 1:
				idx = 0
