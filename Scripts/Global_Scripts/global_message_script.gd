extends Control

@export var message_container: VBoxContainer
@export var user_send_message: RichTextLabel
@export var receiver_send_message: RichTextLabel
@export var message_input: LineEdit
@export var scroll_container: ScrollContainer

var isMessageSend = false

func _ready():
	message_input.visible = false
	scroll_container.get("theme_override_styles/panel").bg_color = Color(0.00, 0.00, 0.00, 0.00)

func _process(_delta: float):
	var socket_data = SocketConnection.socket_data
	receive_message(socket_data)
	
	if isMessageSend:
		await get_tree().create_timer(0.005).timeout
		
		#send data to the backend
		SocketConnection.send_data({
			"Socket_Type": "globalMessage", 
			"Sender": PlayerGlobalScript.player_name, 
			"Message": message_input.text
		})
		isMessageSend = false
		message_input.text = ""
	
func _input(_event):
	if Input.is_action_just_pressed("Chat") and PlayerGlobalScript.modal_open == false:
		chat_open()

func chat_open():
	var color
	
	if PlayerGlobalScript.global_message_open:
		send_message()
		color = Color(0.00, 0.00, 0.00, 0.00)
		PlayerGlobalScript.global_message_open = false
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER

	else:
		color = Color(0.00, 0.00, 0.00, 0.20)
		PlayerGlobalScript.global_message_open = true
		
		await get_tree().process_frame
		message_input.grab_focus()
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		
	message_input.visible = PlayerGlobalScript.global_message_open
	scroll_container.get("theme_override_styles/panel").bg_color = color
	
func send_message():
	var send_content = user_send_message.duplicate()
	
	if not message_input.text.is_empty():
		send_content.visible = true

		send_content.text = PlayerGlobalScript.player_name + ": " + message_input.text
		
		isMessageSend = true
		message_container.add_child(send_content)
		
	await get_tree().process_frame
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)

func receive_message(data):
	if typeof(data) == TYPE_DICTIONARY:
		var receive_content = receiver_send_message.duplicate()
		
		if data.get("Socket_Type") == "globalMessage":
			var receiver_name = data.get("Sender")
			
			if not receiver_name == PlayerGlobalScript.player_name:
				receive_content.visible = true
				receive_content.text = receiver_name + ": " + data.get("Message")
			
				message_container.add_child(receive_content)
				
				await get_tree().process_frame
				scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
				
		#TODO: fix this one
		elif data.get("Socket_Type") == "playerConnected":
			print("Fired the socket connected")
			receive_content.visible = true
			var player_game_name = data.get("Player_Name")
			receive_content.text = player_game_name + " joined the game."
			message_container.add_child(receive_content)
		
			await get_tree().process_frame
			scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
				
		elif data.get("Socket_Type") == "playerDisconnect":
			BackendStuff.send_data_to_express({ "playerCount": -1 }, "/gameData/setPlayerCount")
	
			await get_tree().create_timer(1.0).timeout
			if BackendStuff.returned_parsed["message"] == "success":
				print(data.get("Socket_Type"))
			receive_content.visible = true
			var player_game_name = data.get("Player_Name")
			receive_content.text = player_game_name + " left the game."
			message_container.add_child(receive_content)
		
			await get_tree().process_frame
			scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
