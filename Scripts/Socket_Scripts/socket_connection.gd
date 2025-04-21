extends Node

var websocket_url = "ws://localhost:8080"
var socket := WebSocketPeer.new()
var socket_data = JSON;

#connecting to server status
var connect_server_status = ""
var ping_timer = 0.0

var isConnected = false
var isDisconnected = false

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
		
func connection_evnt():
	emit_signal("connection_status", PlayerGlobalScript.player_name)

#polling
func _process(_delta):
	socket.poll()
	
	#for checking up server connection
	var state = socket.get_ready_state()
	match state:
		WebSocketPeer.STATE_OPEN:
			connect_server_status = "Connected"
			isDisconnected = false
			
			#this is where the "message" go, when stuff from backend send to frontend
			while socket.get_available_packet_count() > 0:
				var raw = socket.get_packet().get_string_from_utf8()
				socket_data = JSON.parse_string(raw)
				server_respond(socket_data)
				
			if PlayerGlobalScript.player_ID_name and isConnected == false:
				isConnected = true
				SocketConnection.send_data({"Socket_Type": "playerConnected", "Player_ID": PlayerGlobalScript.player_ID_name })
		
		WebSocketPeer.STATE_CONNECTING:
			connect_server_status = "Connecting to Server..."
			isConnected = false
			
			if PlayerGlobalScript.player_ID_name and isDisconnected == false:
				isDisconnected = true
				SocketConnection.send_data({"Socket_Type": "playerDisconnected", "Player_ID": PlayerGlobalScript.player_ID_name })
		
		WebSocketPeer.STATE_CLOSING, WebSocketPeer.STATE_CLOSED:
			connect_server_status = "Unable to Connect with the Server"
			isConnected = false
			
			if PlayerGlobalScript.player_ID_name and isDisconnected == false:
				isDisconnected = true
				SocketConnection.send_data({"Socket_Type": "playerDisconnected", "Player_ID": PlayerGlobalScript.player_ID_name })
	
	if connect_server_status == "Connected":
		ping_timer += _delta
	
	if ping_timer >= 5.0:
		send_data({ "send": "ping" })
		ping_timer = 0.0

func server_respond(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("send") == "pong":
			pass

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
			socket.close(1000, "%s left" % [PlayerGlobalScript.player_ID_name])
		get_tree().quit()

func send_data(data):
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var json_string = JSON.stringify(data)
		socket.send_text(json_string)
