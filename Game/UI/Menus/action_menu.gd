extends CanvasLayer


func _on_build_button_pressed():
	# open build menu
	Game.UI.change_action_menu(Game.UI.MENU.BUILD);
	# don't start build action, only when you select a building this should be started;
