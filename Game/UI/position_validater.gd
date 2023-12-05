# TODO make activatable by settings

extends Node2D

const RED_FIELD_COORDS :Vector2 = Vector2(0, 0); # coords in tileset
const GREEN_FIELD_COORDS :Vector2 = Vector2(1, 0);
var validate_tiles :Vector2i = Vector2i(1, 1);
var move_by :Vector2i = Vector2i(0, 0);
var validating = false;
var show_grid = false;
var tile_size :Vector2i = Vector2i.ZERO;

func _ready():
	validate_pos(Vector2i(5, 3), Vector2i(-2, -1));
	tile_size = Game.map.get_node("TileMap").tile_set.tile_size;

func validate(value :bool) -> void:
	validating = value;
	visible = value;
	show_grid = value;

func validate_pos(tiles :Vector2i, offset :Vector2i) -> void:
	move_by = offset;
	validate_tiles = tiles;

func _process(_delta) -> void:
	if (show_grid): # maybe saves performance
		queue_redraw();
	if (!validating): return;
	$ValidatingTiles.clear();
	var fields = [];
	var mouse_grid_coords :Vector2 = $ValidatingTiles.local_to_map(get_global_mouse_position());
	for x in range(mouse_grid_coords.x + move_by.x, mouse_grid_coords.x + validate_tiles.x + move_by.x):
		for y in range(mouse_grid_coords.y + move_by.y, mouse_grid_coords.y + validate_tiles.y + move_by.y):
			var is_valid_field = !Game.map.is_field_occupied(Vector2i(x, y)); # the maps have the same coords
			fields.append(is_valid_field);
			$ValidatingTiles.set_cell(0, Vector2i(x, y), 0, GREEN_FIELD_COORDS if is_valid_field else RED_FIELD_COORDS, 0);
	Game.buildable_pos = true if fields.all(func(e): return e) else false;

func _draw():
	if (show_grid):
		draw_set_transform(Game.map.get_node("TileMap").map_to_local(Game.map.get_node("TileMap").local_to_map(get_global_mouse_position())), 0, Vector2(1, 1));

		var grid_scale :int = 12;

		for y in range(-floor(grid_scale / 2), floor(grid_scale - grid_scale / 2 + 1)):
			draw_line(Vector2(0 - (tile_size.x / 2) - (grid_scale * tile_size.x / 2), y * tile_size.y - (tile_size.y / 2)), Vector2(grid_scale * tile_size.x - (tile_size.y / 2) - (grid_scale * tile_size.x / 2), y * tile_size.y - (tile_size.x / 2)), Color(0.0, 255.0, 255.0, float(1)/float(float(abs(y))/2) if y != 0 else 1));

		for x in range(-floor(grid_scale / 2), floor(grid_scale - grid_scale / 2 + 1)):
			draw_line(Vector2(x * tile_size.x - (tile_size.y / 2), 0 - (tile_size.y  /2) - (grid_scale * tile_size.x / 2)), Vector2(x * tile_size.x - (tile_size.y / 2), grid_scale * tile_size.y - (tile_size.x / 2) - (grid_scale * tile_size.x / 2)), Color(0.0, 255.0, 255.0, float(1)/float(float(abs(x))/2) if x != 0 else 1));

