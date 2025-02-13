extends TileMapLayer

enum Tile { OBSTACLE, START_POINT, END_POINT }

const CELL_SIZE = Vector2i(16, 16)
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color(1, 1, 1, 0.5)

var _astar = AStarGrid2D.new()
var _start_point = Vector2i()
var _end_point = Vector2i()
var _path = PackedVector2Array()

func _ready():
	var used_rect = get_used_rect()
	_astar.region = Rect2i(0, 0, 20, 10)
	_astar.cell_size = CELL_SIZE
	_astar.offset = CELL_SIZE * 0.5
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()

	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			if get_cell_source_id(pos) == Tile.OBSTACLE:
				_astar.set_point_solid(pos)
	
func _draw():
	if _path.is_empty():
		return

	var last_point = map_to_local(_path[0])
	for index in range(1, _path.size()):
		var current_point = map_to_local(_path[index])
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point

func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))

func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	return _astar.is_in_boundsv(map_position) and not _astar.is_point_solid(map_position)

func clear_path():
	if not _path.is_empty():
		_path.clear()
		queue_redraw()

func find_path(local_start_point, local_end_point):
	clear_path()

	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	
	print("Start point:", _start_point, "End point:", _end_point)
	if _astar.is_in_boundsv(_start_point) and _astar.is_in_boundsv(_end_point):
		_path = _astar.get_id_path(_start_point, _end_point)
		print("Path found:", _path)
	
	queue_redraw()
	return _path.duplicate()
