extends CanvasLayer

func _on_barracks_button_pressed():
	Game.selected_building = Game.BUILDINGS.BARRACKS; # Nice Color BrOuW
	Game.change_action(Game.ACTION.BUILD);

func _on_base_button_pressed():
	Game.selected_building = Game.BUILDINGS.MINING_BASE;
	Game.change_action(Game.ACTION.BUILD);
