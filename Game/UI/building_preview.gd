extends Node2D

var active = false;

var buildings = {
	Game.BUILDINGS.BARRACKS: {
		"texture": load("res://MiniWorldSprites/Buildings/Wood/Barracks.png"),
		"size": Vector2i(3, 3), # Vector2i size in tiles to be checked v(width, height)
		"offset": Vector2i(-1, -1),
		"sprite_scale": 10.0,
	},
	Game.BUILDINGS.MINING_BASE: {
		"texture": load("res://MiniWorldSprites/Buildings/Wood/Houses.png"),
		"size": Vector2i(3, 3),
		"offset": Vector2i(-1, -1),
		"sprite_scale": 10.0,
	}
}

func start():
	active = true;
	visible = true;
	$"../PositionValidater".validate(true);

func stop():
	active = false;
	visible = false;
	$"../PositionValidater".validate(false);

# TODO remove
func _ready():
	visible = false;
	#change_building(Game.BUILDINGS.BARRACKS);
	#$"../PositionValidater".validate(true);
	#active = true;

func _process(_delta):
	if (!active): return; # don't do the clutter if you don't have to
	
	position = Game.map.get_node("TileMap").map_to_local(Game.map.get_node("TileMap").local_to_map(get_global_mouse_position()));
	# position transparent tile checkers
	# set buildable position, cause the values are all here, why not just post them from here

func change_building(building_key :int):
	var building = buildings[building_key];
	$"../PositionValidater".validate_pos(building.size, building.offset)
	$Sprite2D.texture = building.texture;
	$Sprite2D.scale = Vector2(building.sprite_scale, building.sprite_scale);
	
