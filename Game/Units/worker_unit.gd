extends CharacterBody2D

var selected;

func _ready():
	# TODO: make dynamic
	self.add_to_group("friendly_units");
	self.add_to_group("controllable_units");

func set_selected(value :bool):
	selected = true;
	$Box.visible = value;
