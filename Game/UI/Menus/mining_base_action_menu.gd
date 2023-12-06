extends CanvasLayer

var building = null;
var worker_unit_scene = preload("res://Game/Units/worker_unit.tscn");

func _on_worker_unit_button_pressed():
	Game.build_unit(worker_unit_scene.instantiate(), building.position) # assign teams etc
	$WorkerUnitButton.release_focus();
