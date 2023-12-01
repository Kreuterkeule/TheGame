# This Script is Global not to be confused with Game root Node!

extends Node2D

var map = null;

var UI = null;

func not_implemented():
	print("ERROR!: This Function should not be caused, your function is not yet implemented");

func _ready():
	for i in range(ACTION.keys().size()): # initialize arrray, empty values can't be written to
		MAP_ACTION_TO_CURSOR.append(null);
		START_ACTION.append(Callable(self, "not_implemented"));
		CLEAN_ACTION.append(Callable(self, "not_implemented"));
	MAP_ACTION_TO_CURSOR[ACTION.BUILD] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.MOVE] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.NO_ACTION] = CURSORS.MOUSE;
	MAP_ACTION_TO_CURSOR[ACTION.SELECT] = CURSORS.SELECT;
	START_ACTION[ACTION.BUILD] = Callable(self, "start_build");
	CLEAN_ACTION[ACTION.BUILD] = Callable(self, "clean_build");
	Input.set_custom_mouse_cursor(MAP_ACTION_TO_CURSOR[ACTION.NO_ACTION]);

var CURSORS = {
	"MOUSE": load("res://assets/cursors/normal.png"),
	"SELECT": load("res://assets/cursors/normal_select.png"),
	"PRECISION": load("res://assets/cursors/precision.png"),
}

var MAP_ACTION_TO_CURSOR = []

enum BUILDINGS { BARRACKS, MINING_BASE };

var SelectedBuilding :int = 0;

var START_ACTION = [];
var CLEAN_ACTION = [];
	
enum ACTION { BUILD, MOVE, SELECT, NO_ACTION } # TODO needs changes

var current_action :int = ACTION.SELECT;
# the idea is actions[current_action].call_func()

func change_action(action :int):
	var old_action = current_action;
	current_action = action;
	CLEAN_ACTION[old_action].call();
	START_ACTION[action].call();
	change_cursor(action);
	
func change_cursor(action :int):
	Input.set_custom_mouse_cursor(MAP_ACTION_TO_CURSOR[action]);


# ACITON SETUP AND CLEAN

func start_build():
	UI.get_node("BuildingPreview").change_building(SelectedBuilding);
	UI.get_node("BuildingPreview").start();
func clean_build():
	UI.get_node("BuildingPreview").stop();
