extends Area2D

var team;

func _ready():
	if (team != Game.team):
		modulate = Color(1, 0 ,0);
