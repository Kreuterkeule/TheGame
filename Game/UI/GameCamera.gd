extends Camera2D

@export var SPEED = 500;

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
		
	
