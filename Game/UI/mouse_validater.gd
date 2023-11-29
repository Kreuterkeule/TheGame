extends Node2D

const RED_FIELD_COORDS :Vector2 = Vector2(0, 0);
const GREEN_FIELD_COORDS :Vector2 = Vector2(1, 0);

func _process(_delta):
	$ValidatingTiles.clear();
	var mouse_grid_coords :Vector2 = $ValidatingTiles.local_to_map(get_global_mouse_position());
	var is_valid_field = !Game.map.is_field_occupied(mouse_grid_coords); # the maps have the same coords
	$ValidatingTiles.set_cell(0, mouse_grid_coords, 0, GREEN_FIELD_COORDS if is_valid_field else RED_FIELD_COORDS, 0);
