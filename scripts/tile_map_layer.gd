extends TileMapLayer

const Cell_size = Vector2i(16, 16)
const base_line_width = 3.0
const draw_color = Color.WHITE * Color(1, 1, 1, 0.5)

var _astar = AStarGrid2D.new()

var _start_point = Vector2i()
var _end_point = Vector2i()
var _path = PackedVector2Array()

func _ready():
	_astar.region = Rect2i(0, 0, 20, 10)
	_astar.cell_size = Cell_size
	_astar.offset = Cell_size * 0.5
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			var tile_data = get_cell_tile_data(pos)
			var tile_type = "empty"
			if tile_data:
				tile_type = tile_data.get_custom_data("type")
			print("Tile at", pos, "has type:", tile_type)
			if tile_type == "obstacle":
				print("Setting obstacle at:", pos)
				_astar.set_point_solid(pos)
			
func _draw():
	if _path.is_empty():
		return
	
	var last_point = _path[0]
	for index in range(1, len(_path)):
		var curr_point = _path[index]
		draw_line(last_point, curr_point, draw_color, base_line_width, true)
		draw_circle(curr_point, base_line_width * 2.0, draw_color)
		last_point = curr_point
		

func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))
	
func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false
	
func clear_path():
	if not _path.is_empty():
		_path.clear()
		queue_redraw()

func set_custom_data(tile_coords: Vector2i, layer_name: String, value):
	var tile_data = get_cell_tile_data(tile_coords)
	if tile_data:
		tile_data.set_custom_data(layer_name, value)
		
func find_path(local_start_point, local_end_point):
	clear_path()
	
	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	_path = _astar.get_id_path(_start_point, _end_point)
	
	if not _path.is_empty():
		set_custom_data(_start_point, "type", "start")
		set_custom_data(_end_point, "type", "end")
			
	queue_redraw()
	return _path.duplicate()
	
func get_tile_type(tile_map: TileMapLayer, tile_coords: Vector2i) -> String:
	var tile_data = tile_map.get_cell_tile_data(tile_coords) 
	if tile_data:
		return tile_data.get_custom_data_layer_value("type") 
	return "unknown" 
