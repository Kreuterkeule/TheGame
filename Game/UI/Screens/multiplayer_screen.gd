extends Control

@export var Address = "127.0.0.1"
@export var port = 7000;
var peer;
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

@rpc("any_peer", "call_local")
func start_game():
	var scene = preload("res://Game/game.tscn").instantiate()
	get_tree().root.add_child(scene);
	Game.multiplayer.set_multiplayer_peer(peer);
	Game.team = multiplayer.get_unique_id();
	Game.controllable_units = get_tree().get_nodes_in_group("controllable_units");
	self.hide();

# server and clients
func peer_connected(id):
	print("Player Connected " + str(id))

# server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id));

# clients
func connected_to_server():
	print("connected to server")
	send_player_information.rpc_id(1, $NameField.text, multiplayer.get_unique_id());

@rpc("any_peer")
func send_player_information(name, id):
	if !Game.players.has(id):
		Game.players[id] = {
			"name": name,
			"id": id,
		};
	if (multiplayer.is_server()):
		for i in Game.players:
			send_player_information.rpc(Game.players[i].name, i)

func connection_failed():
	print("connection failed");

func _on_host_button_button_down():
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, 32);
	if (error != OK):
		print("cannot host server | cause: " + str(error));
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.set_multiplayer_peer(peer);
	print("server startet on port " + str(port));
	send_player_information($NameField.text, multiplayer.get_unique_id());

func _on_join_button_button_down():
	peer = ENetMultiplayerPeer.new();
	peer.create_client(Address, port);
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER);
	multiplayer.set_multiplayer_peer(peer);

func _on_start_game_buttom_button_down():
	start_game.rpc();

func _unhandled_input(_event):
	if (Input.is_action_just_pressed("KEY_F10")): # it's just a key you'll need
		Game.execute(KEY_F10);
