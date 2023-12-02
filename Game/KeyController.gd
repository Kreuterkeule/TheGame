extends Node

func _input(_event):
	if (Input.is_action_just_pressed("escape_key")):
		Game.change_action(Game.ACTION.NO_ACTION);
	if (Input.is_key_pressed(KEY_F10)): # can be changed just for the devs cus fullscreen
		get_tree().quit();
	if (Input.is_key_pressed(KEY_SPACE)):
		Game.execute(Game.INPUT_TYPE.SPACE);
