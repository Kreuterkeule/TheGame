extends Node2D

const layer_count = 2;

func _ready():
	Game.map = self;
	print(get_node("TileMap").get_child_count())

func is_field_occupied(coords :Vector2i):
	var is_occupied = false;
	for layer in range(layer_count):
		var tile_data = $TileMap.get_cell_tile_data(layer, coords);
		if (!tile_data): continue;
		if (tile_data.get_custom_data("occupied")):
			is_occupied = true;
	return is_occupied;
