extends Node

func _input(_event):
	if (Input.is_action_just_pressed("escape_key")):
		Game.change_action(Game.ACTION.NO_ACTION);
