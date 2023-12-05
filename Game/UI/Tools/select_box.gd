extends Node2D

var start_global :Vector2 = Vector2.ZERO;
var end_global :Vector2 = Vector2.ZERO;
var start_local :Vector2 = Vector2.ZERO;
var end_local :Vector2 = Vector2.ZERO;
var is_dragging :bool = false;

func start():
	start_global = get_global_mouse_position();
	start_local = get_local_mouse_position();
	end_global = get_global_mouse_position();
	end_local = get_local_mouse_position();
	is_dragging = true;

func stop():
	end_global = get_global_mouse_position();
	end_local = get_local_mouse_position();
	is_dragging = false;
	return {
		"from": start_global,
		"to": end_global,
	}

func _process(_delta):
	end_global = get_global_mouse_position();
	end_local = get_local_mouse_position();
	draw_area();

func draw_area():
	$Box.size = Vector2(abs(start_local.x - end_local.x), abs(start_local.y - end_local.y));
	var pos = Vector2();
	pos.x = min(start_local.x, end_local.x);
	pos.y = min(start_local.y, end_local.y);
	$Box.position = pos;
	$Box.size *= int(is_dragging)
