extends Node

@export var websocket_url = "ws://localhost:8080"
var socket = WebSocketPeer.new()

var socket_data = "";

#connecting to web sockets
func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		#wait for socket to connect
		await get_tree().create_timer(1).timeout
		print("Connected to the web socket")

#polling
func _process(_delta):
	socket.poll()

	#this is where the "message" go, when stuff from backend send to frontend
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			socket_data = JSON.parse_string(socket.get_packet().get_string_from_utf8())

func send_data(data):
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var json_string = JSON.stringify(data)
		socket.send_text(json_string)
