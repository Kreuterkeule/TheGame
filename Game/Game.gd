# This Script is Global not to be confused with Game root Node!

extends Node2D

# PRELOADED SCENES
var barracks_scene = preload("res://Game/Buildings/building_barracks.tscn");
var mining_base_scene = preload("res://Game/Buildings/building_mining_base.tscn")

var controllable_units = [];
var selected_units = [];

var selected_building_ref;

var map = null;

var UI = null;

var mouse_over = null;

var buildable_pos = true;

var team;

var players = {}

func _process(_delta):
	print(mouse_over);
	pass;

func not_implemented():
	print_debug("ERROR!: This Function should not be caused, your function is not yet implemented");

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	for i in range(ACTION.keys().size()): # initialize arrray, empty values can't be written to
		MAP_ACTION_TO_CURSOR.append(null);
		START_ACTION.append(Callable(self, "not_implemented"));
		CLEAN_ACTION.append(Callable(self, "not_implemented"));
	MAP_ACTION_TO_CURSOR[ACTION.BUILD] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.MOVE] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.NO_ACTION] = CURSORS.MOUSE;
	MAP_ACTION_TO_CURSOR[ACTION.SELECT] = CURSORS.SELECT;
	MAP_ACTION_TO_CURSOR[ACTION.SELECT_BUILDING] = CURSORS.SELECT;
	START_ACTION[ACTION.BUILD] = Callable(self, "start_build");
	CLEAN_ACTION[ACTION.BUILD] = Callable(self, "clean_build");
	START_ACTION[ACTION.NO_ACTION] = Callable(self, "start_no_action");
	CLEAN_ACTION[ACTION.NO_ACTION] = Callable(self, "clean_no_action");
	self.change_action(ACTION.NO_ACTION);



var CURSORS = {
	"MOUSE": load("res://assets/cursors/normal.png"),
	"SELECT": load("res://assets/cursors/normal_select.png"),
	"PRECISION": load("res://assets/cursors/precision.png"),
}

enum NODE_TYPE { BUILDING, UNIT }
enum BUILDINGS { BARRACKS, MINING_BASE };
enum ACTION { BUILD, MOVE, SELECT, NO_ACTION, SELECT_BUILDING, CONTROLLING_UNIT } # TODO needs changes
enum INPUT_TYPE { PRIMARY, SECONDARY, SPACE }

var selected_building :int = 0;

var MAP_ACTION_TO_CURSOR = []
var START_ACTION = [];
var CLEAN_ACTION = [];
var BUILD = {
	BUILDINGS.BARRACKS: Callable(self, "create_barracks"),
	BUILDINGS.MINING_BASE: Callable(self, "create_mining_base"),
}
var INPUT_MAP = {
	"primary_mouse_button": {
		ACTION.BUILD: Callable(self, "build"),
		ACTION.NO_ACTION: Callable(self, "start_select"),
	},
	"primary_mouse_button_released": {
		ACTION.SELECT: Callable(self, "end_select"),
	},
	"secondary_mouse_button": {
		ACTION.BUILD: Callable(self, "exit_build"), # usabillity? if not remove
		ACTION.NO_ACTION: Callable(self, "move_units"),
	},
	KEY_SPACE: {
		ACTION.BUILD: Callable(self, "not_implemented"), # submit build
		ACTION.NO_ACTION: Callable(self, "not_implemented"),
		ACTION.MOVE: Callable(self, "not_implemented"),
		ACTION.SELECT: Callable(self, "not_implemented"),
	},
	KEY_A: {
		ACTION.NO_ACTION: Callable(self, "not_implemented"),
	},
	KEY_B: {
		ACTION.NO_ACTION: Callable(self, "build_select_building"),
		ACTION.SELECT_BUILDING: Callable(self, "preview_barracks"),
	},
	KEY_M: {
		ACTION.SELECT_BUILDING: Callable(self, "preview_mining_base"),
	},
	KEY_F10: {
		"is_global_action": true, # this event does not change on different actions
		"method": Callable(self, "exit_game"),
	},
	KEY_ESCAPE: {
		ACTION.BUILD: Callable(self, "exit_build"), # Nice, that this works
		ACTION.SELECT_BUILDING: Callable(self, "exit_select_building"),
		ACTION.NO_ACTION: Callable(self, "clean_all_actions"), # for good measures
	},
	KEY_R: {
		"is_global_action": true,
		"method": Callable(self, "reset_camera"),
	},
};

var current_action :int = ACTION.NO_ACTION;
# the idea is actions[current_action].call()

func execute(input_key):
	if (!INPUT_MAP.has(input_key)):
		return;
	if (!INPUT_MAP[input_key].has(current_action)):
		if (INPUT_MAP[input_key].has("is_global_action")): # could check for the value, but what if the value isn't set yet
			INPUT_MAP[input_key].method.call();
			return;
		else:
			return;
	INPUT_MAP[input_key][current_action].call();

func change_action(action :int):
	var old_action = current_action;
	current_action = action;
	CLEAN_ACTION[old_action].call();
	START_ACTION[action].call();
	change_cursor(action);
	
func change_cursor(action :int):
	Input.set_custom_mouse_cursor(MAP_ACTION_TO_CURSOR[action]);

# INPUT FUNCTIONS

func move_units():
	var mouse_pos = get_global_mouse_position();
	for unit in selected_units:
		unit.set_target(mouse_pos);
		unit.set_state(unit.STATE.MOVING);
func start_select():
	UI.get_node("SelectBox").start();
	change_action(ACTION.SELECT);
func end_select():
	var bounds = UI.get_node("SelectBox").stop();
	for unit in selected_units:
		unit.set_selected(false);
	selected_units = [];
	if (selected_building_ref):
		selected_building_ref.deselect();
		selected_building_ref = null;
	if bounds.from.distance_to(bounds.to) < 10:
		if mouse_over:
			# TODO handle click on unit (group with just one unit);
			if (mouse_over.type == NODE_TYPE.UNIT):
				selected_units.append(mouse_over);
				mouse_over.select();
			if (mouse_over.type == NODE_TYPE.BUILDING):
				selected_building_ref = mouse_over;
				selected_building_ref.select();
		change_action(ACTION.NO_ACTION)
	else:
		change_action(ACTION.NO_ACTION);
		select_units(bounds);

func reset_camera():
	UI.get_node("GameCamera").position = Vector2.ZERO;

func build_select_building():
	UI.change_action_menu(UI.MENU.BUILD);

func exit_select_building():
	UI.change_action_menu(UI.default_menu);
	reset_action();
func exit_build():
	UI.change_action_menu(UI.default_menu);
	reset_action();

func clean_all_actions():
	for action in ACTION.keys():
		CLEAN_ACTION[ACTION[action]].call();
func reset_action():
	change_action(ACTION.NO_ACTION);

# ACITON SETUP AND CLEAN

func start_build():
	UI.get_node("BuildingPreview").change_building(selected_building);
	UI.get_node("BuildingPreview").start();
func clean_build():
	UI.get_node("BuildingPreview").stop();
	UI.change_action_menu(UI.MENU.ACTION);

func start_no_action():
	pass;
func clean_no_action():
	pass;

# PREVIEW BUILDINGS

func preview_barracks():
	UI.get_node("Menus/BuildMenu/BarracksButton").emit_signal("pressed");
func preview_mining_base():
	UI.get_node("Menus/BuildMenu/MiningBaseButton").emit_signal("pressed");	

# BUILD BUILDINGS

func build():
	BUILD[selected_building].call();

func create_barracks():
	var pos = get_global_mouse_position();	
	if (!map.validate_pos(pos, BUILDINGS.BARRACKS)):
		change_action(ACTION.NO_ACTION);
		return;
	build_barracks.rpc(pos, team);
	change_action(ACTION.NO_ACTION);	
@rpc("any_peer", "call_local")
func build_barracks(pos :Vector2, t):
	var barracks = barracks_scene.instantiate();
	barracks.position = Game.map.get_node("TileMap").map_to_local(Game.map.get_node("TileMap").local_to_map(pos));
	barracks.team = t;
	map.occupie_tiles(barracks.position, BUILDINGS.BARRACKS);
	map.get_node("Buildings").add_child(barracks)
func create_mining_base():
	var pos = get_global_mouse_position();
	if (!map.validate_pos(pos, BUILDINGS.MINING_BASE)):
		change_action(ACTION.NO_ACTION);
		return;
	build_mining_base.rpc(pos, team);
	change_action(ACTION.NO_ACTION);	
@rpc("any_peer", "call_local")
func build_mining_base(pos :Vector2, t):
	var mining_base = mining_base_scene.instantiate();
	mining_base.position = Game.map.get_node("TileMap").map_to_local(Game.map.get_node("TileMap").local_to_map(pos));
	mining_base.team = t;
	mining_base.position -= Vector2(24, 24); # has an even tilesize
	map.occupie_tiles(mining_base.position, BUILDINGS.MINING_BASE);
	map.get_node("Buildings").add_child(mining_base);

func select_units(bounds):
	var start = bounds.from;
	var end = bounds.to;
	var area = [];
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)));
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)));
	var ut = get_units_in_area(area);
	for u in controllable_units:
		u.set_selected(false);
	for u in ut:
		u.set_selected(true);
	selected_units = ut;

func build_unit(unit, spawn_position):
	build_unit_rpc.rpc(unit, spawn_position, team);
@rpc("any_peer", "call_local")
func build_unit_rpc(unit, spawn_position, target_team):
	unit.position = spawn_position - Vector2(60 * randi_range(-1 ,1), 60 * randi_range(-1 ,1)); # temp offset
	unit.team = target_team;
	map.get_node("Units").add_child(unit);
	if (team == target_team):
		update_controllable_units();

func get_units_in_area(area):
	var u = []
	for unit in controllable_units:
		if (unit.position.x > area[0].x and unit.position.x < area[1].x and unit.position.y > area[0].y and unit.position.y < area[1].y):
			u.append(unit);
	return u;

func update_controllable_units():
	controllable_units = get_tree().get_nodes_in_group("controllable_units");

func exit_game():
	get_tree().quit();
