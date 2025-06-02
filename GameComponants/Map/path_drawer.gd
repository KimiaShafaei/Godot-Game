extends Node2D

const base_line_width = 2.0
const draw_color = Color.ORANGE_RED * Color(1, 1, 0, 0.8)
const end_marker_size = 5.0
const marker_rotation = -90.0
const curve_steps = 32

var _path = PackedVector2Array()

func update_path(new_path: PackedVector2Array):
	_path = new_path
	queue_redraw()

func _draw():
	if _path.size() < 2:
		return

	var filled_path = _path.duplicate()

	# 🧠 Pad points to form valid cubic segments
	while (filled_path.size() - 1) % 3 != 0:
		filled_path.append(filled_path[-1])

	var points = PackedVector2Array()

	var i = 0
	while i + 3 < filled_path.size():
		var p0 = filled_path[i]
		var p1 = filled_path[i + 1]
		var p2 = filled_path[i + 2]
		var p3 = filled_path[i + 3]

		for j in range(curve_steps + 1):
			var t = j / float(curve_steps)
			points.append(get_cubic_bezier_point(t, p0, p1, p2, p3))

		i += 3  # chain segments

	draw_polyline(points, draw_color, base_line_width, true)

	# 🏹 Arrowhead on end
	if points.size() >= 2:
		var end_point = points[-1]
		var prev_point = points[-2]
		var direction_vector = prev_point - end_point
		var angle = direction_vector.angle()
		var marker_points = [
			Vector2(-end_marker_size, end_marker_size),
			Vector2(end_marker_size, end_marker_size),
			Vector2(0, -end_marker_size)
		]

		for idx in marker_points.size():
			marker_points[idx] = marker_points[idx].rotated(angle + deg_to_rad(marker_rotation)) + end_point

		draw_polygon(PackedVector2Array(marker_points), PackedColorArray([draw_color]))

func get_cubic_bezier_point(t: float, p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2:
	return pow(1 - t, 3) * p0 \
		+ 3 * pow(1 - t, 2) * t * p1 \
		+ 3 * (1 - t) * t * t * p2 \
		+ pow(t, 3) * p3
