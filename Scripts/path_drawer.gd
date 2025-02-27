extends Node2D

const base_line_width = 2.0
const draw_color = Color.ORANGE_RED * Color(1, 1, 0, 0.8)
const end_marker_size = 5.0
const marker_rotation = -90.0

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
		last_point = curr_point
	
	var end_point = _path[-1]
	var prev_point = _path[_path.size() - 2]
	var direction_vector = prev_point - end_point
	var angle = direction_vector.angle()
	var marker_points = [
		Vector2(-end_marker_size, end_marker_size),
		Vector2(end_marker_size, end_marker_size),
		Vector2(0, -end_marker_size)
	]
	
	var rotate_marker = []
	for p in marker_points:
		rotate_marker.append(p.rotated(angle + deg_to_rad(marker_rotation)))
	
	for i in range(rotate_marker.size()):
		rotate_marker[i] += end_point
	
	var triangle_color = PackedColorArray([draw_color])
	draw_polygon(PackedVector2Array(rotate_marker), triangle_color)
