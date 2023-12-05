extends Node2D

const LAYER_COUNT = 2;
const GROUND_LAYER = 0;

var buildings = {
	Game.BUILDINGS.MINING_BASE: {
		"texture": load("res://MiniWorldSprites/Buildings/Wood/Barracks.png"),
		"size": Vector2i(2, 2), # Vector2i size in tiles to be checked v(width, height)
		"offset": Vector2i(-1, -1),
		"sprite_scale": 5,
		"animation": Vector2i(4, 5),
		"frame": 5,
	},
	Game.BUILDINGS.BARRACKS: {
		"texture": load("res://MiniWorldSprites/Buildings/Wood/Houses.png"),
		"size": Vector2i(3, 3),
		"offset": Vector2i(-1, -1),
		"sprite_scale": 8.0,
		"animation": Vector2i(3, 4),
		"frame": 0,
	}
}

var occupied_map = {};

func _ready():
	Game.map = self;
	for cell_coords in $TileMap.get_used_cells(GROUND_LAYER):
		occupied_map[cell_coords] = is_field_occupied_by_tile_data(cell_coords);

func validate_pos(position :Vector2, building :int) -> bool:
	var move_by = buildings[building].offset;
	var validate_tiles = buildings[building].size;
	var fields = [];
	var mouse_grid_coords :Vector2 = $TileMap.local_to_map(position);
	for x in range(mouse_grid_coords.x + move_by.x, mouse_grid_coords.x + validate_tiles.x + move_by.x):
		for y in range(mouse_grid_coords.y + move_by.y, mouse_grid_coords.y + validate_tiles.y + move_by.y):
			var is_valid_field = !Game.map.is_field_occupied(Vector2i(x, y)); # the maps have the same coords
			fields.append(is_valid_field);
	return true if fields.all(func(e): return e) else false;

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

func occupie_tiles(position, building :int):
	var move_by = buildings[building].offset;
	var validate_tiles = buildings[building].size;
	var grid_position = $TileMap.local_to_map(position);
	for x in range(grid_position.x + move_by.x, grid_position.x + validate_tiles.x + move_by.x):
		for y in range(grid_position.y + move_by.y, grid_position.y + validate_tiles.y + move_by.y):
			Game.map.occupied_map[Vector2i(x, y)] = true;
