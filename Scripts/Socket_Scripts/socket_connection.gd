extends Node

var websocket_url = "ws://localhost:8080"
var socket = WebSocketPeer.new()
var socket_data = "";

#connecting to server status
var connect_server_status = ""

#connecting to web sockets
func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		connect_server_status = "Not Connected"
		set_process(false)
	else:
		#wait for socket to connect
		await get_tree().create_timer(1).timeout

#polling
func _process(_delta):
	socket.poll()
	
	#for checking up server connection
	var state = socket.get_ready_state()
	match state:
		WebSocketPeer.STATE_OPEN:
			connect_server_status = "Connected"
			
			#this is where the "message" go, when stuff from backend send to frontend
			while socket.get_available_packet_count():
				socket_data = JSON.parse_string(socket.get_packet().get_string_from_utf8())
		
		WebSocketPeer.STATE_CONNECTING:
			connect_server_status = "Connecting to Server..."
		
		WebSocketPeer.STATE_CLOSING, WebSocketPeer.STATE_CLOSED:
			connect_server_status = "Unable to Connect with the Server"

func reconnect_to_server():
	var err = socket.connect_to_url(websocket_url)
	connect_server_status = "Attempting to reconnect with the server..."
	
	if err != OK:
		print("Unable to connect")
		connect_server_status = "Not Connected"
		set_process(false)
	else:
		#wait for socket to connect
		await get_tree().create_timer(1).timeout

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			send_data({"Socket_Type": "playerDisconnect", "Player_Name": PlayerGlobalScript.player_name })
			socket.close(1000, "%s left" % [PlayerGlobalScript.player_name])
		get_tree().quit()

func send_data(data):
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var json_string = JSON.stringify(data)
		socket.send_text(json_string)
