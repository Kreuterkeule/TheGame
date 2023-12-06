extends CharacterBody2D

const type = Game.NODE_TYPE.UNIT;
var selected;
@export var speed = 200;
var current_state :int = STATE.HOLD;
@onready var navigator: NavigationAgent2D = $NavigationAgent2D;
@onready var rays = $Rays;
@onready var ray_front = $Rays/RayFront;
var team;

enum STATE { MOVING, ATTACKING, ATTACK_MOVE, HOLD, IDLE }
var target :Vector2;
var state_map = {
	STATE.MOVING: Callable(self, "move"),
	STATE.ATTACKING: Callable(self, "attack"),
	STATE.ATTACK_MOVE: Callable(self, "attack_move"),
	STATE.HOLD: Callable(self, "hold"),
	STATE.IDLE: Callable(self, "idle"),
}

func set_state(state :int):
	current_state = state;

func set_target(value :Vector2):
	target = value

func _ready():
	# TODO: make dynamic
	self.add_to_group("friendly_units");
	self.add_to_group("controllable_units");
	
	if (team != Game.team):
		$Sprite2D.modulate = Color(255, 0, 0, 0.5);
	
	navigator.path_desired_distance = 48.0;
	navigator.target_desired_distance = 48.0;
	call_deferred("actor_setup")
	for ray in rays.get_children():
		ray.add_exception(self);

func actor_setup():
	await get_tree().physics_frame

func _draw():
	if (current_state == STATE.MOVING or current_state == STATE.ATTACK_MOVE):
		draw_line(to_local(position), to_local(target), Color(0, 255, 0, 1), 1, true);

func _process(_delta):
	if (current_state == STATE.MOVING or current_state == STATE.ATTACK_MOVE):
		queue_redraw();
	state_map[current_state].call();

func select():
	# TODO: unit action menu in Game.UI
	set_selected(true);

func deselect():
	set_selected(false);

func set_selected(value :bool):
	selected = true;
	$Box.visible = value;

func move():
	if (position.distance_to(target) < 10):
		current_state = STATE.IDLE;
	navigator.target_position = target;
	if (navigator.is_navigation_finished()): return;
	var current_agent_position: Vector2 = global_position;
	var next_path_position: Vector2 = navigator.get_next_path_position();
	
	velocity = current_agent_position.direction_to(next_path_position) * speed;
	move_with_avoidance(next_path_position);

func move_with_avoidance(tar):
	rays.rotation = velocity.angle();
	if _obstacle_ahead():
		var viable_ray = _get_viable_ray();
		if (viable_ray):
			velocity = Vector2.RIGHT.rotated(rays.rotation + viable_ray.rotation) * speed;
	move_and_slide();

func _obstacle_ahead() -> bool:
	return ray_front.is_colliding();

func _get_viable_ray() -> RayCast2D:
	for ray in rays.get_children():
		if !ray.is_colliding():
			return ray;
	return null;

func attack(target):
	if (!target):
		# auto attack
		pass;
	pass;

func attack_move():
	# move, but attack if enemy in sight, if enemy killed, keep moving to target
	pass;

func hold():
	pass;

func idle():
	pass; # hold, but walk to enemies if they appear


func _on_mouse_entered(): # dont forget to make unit pickable :>
	Game.mouse_over = self;


func _on_mouse_exited():
	if (Game.mouse_over == self):
		Game.mouse_over = null;
