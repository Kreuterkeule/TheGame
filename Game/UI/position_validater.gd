# TODO make activatable by settings

extends Node2D

const RED_FIELD_COORDS :Vector2 = Vector2(0, 0);
const GREEN_FIELD_COORDS :Vector2 = Vector2(1, 0);
@export var validate_tiles :Vector2i = Vector2i(1, 1);
@export var move_by :Vector2i = Vector2i(0, 0);
var validating = false;

func _ready():
	validate(true);
	validate_pos(Vector2i(5, 3), Vector2i(-2, -1));

func validate(value :bool) -> void:
	validating = value;

func validate_pos(tiles :Vector2i, offset :Vector2i) -> void:
	move_by = offset;
	validate_tiles = tiles;

func _process(_delta) -> void:
	if (!validating): return;
	$ValidatingTiles.clear();
	var mouse_grid_coords :Vector2 = $ValidatingTiles.local_to_map(get_global_mouse_position());
	for x in range(mouse_grid_coords.x + move_by.x, mouse_grid_coords.x + validate_tiles.x + move_by.x):
		for y in range(mouse_grid_coords.y + move_by.y, mouse_grid_coords.y + validate_tiles.y + move_by.y):
			var is_valid_field = !Game.map.is_field_occupied(Vector2i(x, y)); # the maps have the same coords
			$ValidatingTiles.set_cell(0, Vector2i(x, y), 0, GREEN_FIELD_COORDS if is_valid_field else RED_FIELD_COORDS, 0);
