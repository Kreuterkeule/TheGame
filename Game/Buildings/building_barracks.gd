extends StaticBody2D

var team;

func _ready():
	if (team != Game.team):
		modulate = Color(1, 0 ,0);

func _on_mouse_entered():
	print("MOUSE ENTERED BUILDING BARRACKS")
	Game.mouse_over = self;


func _on_mouse_exited():
	if Game.mouse_over == self:
		Game.mouse_over = null;
