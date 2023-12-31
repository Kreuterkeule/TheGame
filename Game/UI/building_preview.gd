extends Node2D

var active = false;
var x_even = false;
var y_even = false;

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
	if y_even:
		position.y -= 24; # half the tile_size;
	if x_even:
		position.x -= 24;
	# position transparent tile checkers
	# set buildable position, cause the values are all here, why not just post them from here

func change_building(building_key :int):
	var building = Game.map.buildings[building_key];
	$"../PositionValidater".validate_pos(building.size, building.offset)
	$Sprite2D.texture = building.texture;
	$Sprite2D.scale = Vector2(building.sprite_scale, building.sprite_scale);
	$Sprite2D.hframes = building.animation.x;
	$Sprite2D.vframes = building.animation.y;
	$Sprite2D.frame = building.frame;
	x_even = false if building.size.x % 2 else true;
	y_even = false if building.size.y % 2 else true;
	
