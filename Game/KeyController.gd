extends Node

func _process(delta):
	if (Input.is_action_just_pressed("KEY_B")):
		Game.execute(KEY_B);
	if (Input.is_action_just_pressed("KEY_F10")):
		Game.execute(KEY_F10);
	if (Input.is_action_just_pressed("KEY_ESCAPE")):
		Game.execute(KEY_ESCAPE);
	if (Input.is_action_just_pressed("KEY_SPACE")):
		Game.execute(KEY_SPACE);
	if (Input.is_action_just_pressed("KEY_A")):
		Game.execute(KEY_A);
	if (Input.is_action_just_pressed("KEY_M")):
		Game.execute(KEY_M);
