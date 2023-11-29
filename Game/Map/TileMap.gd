extends TileMap


func _ready():
	var tile_data = get_cell_tile_data(0, Vector2i.ZERO);
	var is_occupied :bool = tile_data.get_custom_data("occupied");
	
	print("is_occupied: {0}".format(is_occupied));
