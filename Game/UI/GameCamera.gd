extends Camera2D

@export var SPEED = 500;

const MAX_ZOOM :float = 2;
const MIN_ZOOM :float = 0.1;
const ZOOM_SPEED :Vector2 = Vector2(0.1, 0.1);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mp = get_window().get_mouse_position();
	
	if (mp.x < 5):
		self.position += SPEED * delta * Vector2(-1, 0);
	if (mp.x > get_window().size.x - 5):
		self.position += SPEED * delta * Vector2(1, 0);		
	if (mp.y < 5):
		self.position += SPEED * delta * Vector2(0, -1);		
	if (mp.y > get_window().size.y - 5):
		self.position += SPEED * delta * Vector2(0, 1);

func _input(event):
	
	if (Input.is_action_pressed("scroll_down") && self.zoom.x + ZOOM_SPEED.x <= MAX_ZOOM):
		self.zoom += ZOOM_SPEED;
	if (Input.is_action_just_pressed("scroll_up") && self.zoom.x - ZOOM_SPEED.x >= MIN_ZOOM):
		self.zoom -= ZOOM_SPEED;
