extends Node2D

const base_line_width = 2.0
const draw_color = Color.WHITE * Color(1, 1, 1, 0.5)

var _path = PackedVector2Array()

func update_path(new_path: PackedVector2Array):
	_path = new_path
	if _path.is_empty():
		queue_redraw()
	
	
func _draw():
	if _path.is_empty():
		return
	
	var last_point = _path[0]
	for index in range(1, len(_path)):
		var curr_point = _path[index]
		draw_line(last_point, curr_point, draw_color, base_line_width, true)
		draw_circle(curr_point, base_line_width * 2.0, draw_color)
		last_point = curr_point
