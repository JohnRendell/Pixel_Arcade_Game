extends Control

@export var message_container: VBoxContainer
@export var user_send_message: RichTextLabel
@export var receiver_send_message: RichTextLabel
@export var message_input: LineEdit
@export var scroll_container: ScrollContainer

var isChatOpen = false

func _ready():
	message_input.visible = isChatOpen
	scroll_container.get("theme_override_styles/panel").bg_color = Color(0.00, 0.00, 0.00, 0.00)

func _process(_delta: float):
	var socket_data = SocketConnection.socket_data
	receive_message(socket_data)
	
func _input(_event):
	if Input.is_action_just_pressed("Chat"):
		chat_open()

func chat_open():
	var color
	
	if isChatOpen:
		send_message()
		color = Color(0.00, 0.00, 0.00, 0.00)
		isChatOpen = false
		scroll_container.vertical_scroll_mode = 3

	else:
		color = Color(0.00, 0.00, 0.00, 0.20)
		isChatOpen = true
		
		await get_tree().process_frame
		message_input.grab_focus()
		scroll_container.vertical_scroll_mode = 1
		
	PlayerGlobalScript.modal_open = isChatOpen
	message_input.visible = isChatOpen
	scroll_container.get("theme_override_styles/panel").bg_color = color
	
func send_message():
	var send_content = user_send_message.duplicate()
	
	if not message_input.text.is_empty():
		send_content.visible = true
		send_content.text = PlayerGlobalScript.player_name + ": " + message_input.text
		
		#send data to the backend
		SocketConnection.send_data({
			"Socket_Type": "globalMessage", 
			"Sender": PlayerGlobalScript.player_name, 
			"Message": message_input.text
		})
		
		message_container.add_child(send_content)
		
	message_input.text = ""
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

#TODO make a work around on this, fix the data not sending back from server to godot
func receive_message(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "globalMessage":
			print(data)
			var receive_content = receiver_send_message.duplicate()
			var receiver_name = data.get("Sender")
			
			if not receiver_name == PlayerGlobalScript.player_name:
				receive_content.visible = true
				receive_content.text = receiver_name + ": " + data.get("Message")
			
				message_container.add_child(receive_content)
