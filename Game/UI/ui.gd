extends Node2D

enum MENU { BUILD, ACTION }

@export var default_menu = MENU.ACTION;
var old_menu :int = -1;

var CLEAN_MENU = {
	MENU.BUILD: Callable(self, "clean_action_menu_build"),
	MENU.ACTION: Callable(self, "clean_action_menu_action"),
};
var ACTIVATE_MENU = {
	MENU.BUILD: Callable(self, "activate_action_menu_build"),
	MENU.ACTION: Callable(self, "activate_action_menu_action"),
};

func _ready():
	Game.UI = self;
	for menu in $Menus.get_children():
		menu.hide();
	change_action_menu(default_menu);

func change_action_menu(new_menu :int):
	if old_menu != -1:
		CLEAN_MENU[old_menu].call();
	ACTIVATE_MENU[new_menu].call();
	old_menu = new_menu;

func clean_action_menu_build():
	$Menus/BuildMenu.hide();

func clean_action_menu_action():
	$Menus/ActionMenu.hide();

func activate_action_menu_build():
	Game.change_action(Game.ACTION.SELECT_BUILDING); # changes keymap	
	$Menus/BuildMenu.show();

func activate_action_menu_action():
	Game.change_action(Game.ACTION.NO_ACTION);
	$Menus/ActionMenu.show();
