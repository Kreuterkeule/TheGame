extends StaticBody2D

var team;
var selected :bool = false;
const type = Game.NODE_TYPE.BUILDING;

func _ready():
	if (team != Game.team):
		modulate = Color(1, 0 ,0);

func select():
	# UI.start_building_menu ...
	selected = true;
	$Box.visible = true;

func deselect():
	# reset_menu
	selected = false;
	$Box.visible = false;

func _on_mouse_entered():
	Game.mouse_over = self;


func _on_mouse_exited():
	if Game.mouse_over == self:
		Game.mouse_over = null;
