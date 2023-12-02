extends Node2D

func _input(event):
	if (Input.is_action_just_pressed("primary_mouse_button")):
		Game.execute(Game.INPUT_TYPE.PRIMARY);
	if (Input.is_action_just_pressed("secondary_mouse_button")):
		Game.execute(Game.INPUT_TYPE.SECONDARY);
	if (Input.is_action_just_released("primary_mouse_button")):
		pass;
	if (Input.is_action_just_released("secondary_mouse_button")):
		pass;
