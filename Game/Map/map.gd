extends Node2D

const LAYER_COUNT = 2;
const GROUND_LAYER = 0;

var occupied_map = {};

func _ready():
	Game.map = self;
	for cell_coords in $TileMap.get_used_cells(GROUND_LAYER):
		occupied_map[cell_coords] = is_field_occupied_by_tile_data(cell_coords);


func is_field_occupied_by_tile_data(coords :Vector2i):
	var is_occupied = false;
	for layer in range(LAYER_COUNT):
		var tile_data = $TileMap.get_cell_tile_data(layer, coords);
		if (!tile_data): continue;
		if (tile_data.get_custom_data("occupied")):
			is_occupied = true;
	return is_occupied;


func is_field_occupied(coords: Vector2i):
	if (!occupied_map.has(coords)):
		return false;
	return occupied_map[coords];
