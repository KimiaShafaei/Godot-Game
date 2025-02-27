extends TileMapLayer

const Cell_size = Vector2i(32, 32)

var _astar = AStarGrid2D.new()

var _start_point = Vector2i()
var _end_point = Vector2i()

@onready var path_drawer = $PathDrawer

func _ready():
	_astar.region = Rect2i(0, 0, 25, 13)
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
			if tile_type == "obstacle":
				_astar.set_point_solid(pos)
			

func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))
	
func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false
	
func clear_path():
	path_drawer.update_path(PackedVector2Array())
	
	
func set_custom_data(tile_coords: Vector2i, layer_name: String, value):
	var tile_data = get_cell_tile_data(tile_coords)
	if tile_data:
		tile_data.set_custom_data(layer_name, value)
		
func find_path(local_start_point, local_end_point):
	clear_path()

	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	var _path = _astar.get_id_path(_start_point, _end_point)
	print("path", _path)
	if not _path.is_empty():
		set_custom_data(_start_point, "type", "start")
		set_custom_data(_end_point, "type", "end")
		
		path_drawer.update_path(PackedVector2Array(_path.map(func(p): return map_to_local(p))))
	
	queue_redraw()
	return _path.duplicate()
	
func get_tile_type(tile_map: TileMapLayer, tile_coords: Vector2i) -> String:
	var tile_data = tile_map.get_cell_tile_data(tile_coords) 
	if tile_data:
		return tile_data.get_custom_data_layer_value("type") 
	return "unknown" 
