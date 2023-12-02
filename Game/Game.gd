# This Script is Global not to be confused with Game root Node!

extends Node2D

var map = null;

var UI = null;

func not_implemented():
	print("ERROR!: This Function should not be caused, your function is not yet implemented");

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	for i in range(ACTION.keys().size()): # initialize arrray, empty values can't be written to
		MAP_ACTION_TO_CURSOR.append(null);
		START_ACTION.append(Callable(self, "not_implemented"));
		CLEAN_ACTION.append(Callable(self, "not_implemented"));
		ACTION_EXECUTE.append(Callable(self, "not_implemented"));
	MAP_ACTION_TO_CURSOR[ACTION.BUILD] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.MOVE] = CURSORS.PRECISION;
	MAP_ACTION_TO_CURSOR[ACTION.NO_ACTION] = CURSORS.MOUSE;
	MAP_ACTION_TO_CURSOR[ACTION.SELECT] = CURSORS.SELECT;
	START_ACTION[ACTION.BUILD] = Callable(self, "start_build");
	CLEAN_ACTION[ACTION.BUILD] = Callable(self, "clean_build");
	START_ACTION[ACTION.NO_ACTION] = Callable(self, "start_no_action");
	CLEAN_ACTION[ACTION.NO_ACTION] = Callable(self, "clean_no_action");
	ACTION_EXECUTE[ACTION.BUILD] = Callable(self, "execute_build");
	ACTION_EXECUTE[ACTION.SELECT] = Callable(self, "execute_select");
	ACTION_EXECUTE[ACTION.MOVE] = Callable(self, "execute_move");
	ACTION_EXECUTE[ACTION.NO_ACTION] = Callable(self, "execute_nothing");
	self.change_action(ACTION.NO_ACTION);



var CURSORS = {
	"MOUSE": load("res://assets/cursors/normal.png"),
	"SELECT": load("res://assets/cursors/normal_select.png"),
	"PRECISION": load("res://assets/cursors/precision.png"),
}


enum BUILDINGS { BARRACKS, MINING_BASE };
enum ACTION { BUILD, MOVE, SELECT, NO_ACTION } # TODO needs changes
enum INPUT_TYPE { PRIMARY, SECONDARY, SPACE }

var selected_building :int = 0;

var MAP_ACTION_TO_CURSOR = []
var START_ACTION = [];
var CLEAN_ACTION = [];
var ACTION_EXECUTE = []; # action that should be called on event

var current_action :int = ACTION.NO_ACTION;
# the idea is actions[current_action].call_func()

func execute(input_type :int):
	pass

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
	UI.get_node("BuildingPreview").change_building(selected_building);
	UI.get_node("BuildingPreview").start();
func clean_build():
	UI.get_node("BuildingPreview").stop();
	
func start_no_action():
	pass;
func clean_no_action():
	pass;

func execute_nothing():
	print("is there anything to do here?");

func execute_build():
	pass;

func execute_select():
	pass;

func execute_move():
	pass;
