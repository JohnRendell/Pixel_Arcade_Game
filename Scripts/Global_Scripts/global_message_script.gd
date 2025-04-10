extends Control

@export var message_container: VBoxContainer
@export var user_send_message: RichTextLabel
@export var message_input: TextEdit
@export var scroll_container: ScrollContainer
@export var global_message: Control
@export var send_button: Button


func _ready() -> void:
	global_message.visible = false
	global_message.add_theme_color_override("BG Color", "#72727200")

#TODO: make this work properly
func _process(_delta: float):
	var socket_data = SocketConnection.socket_data
	receive_message(socket_data)
	
	if Input.is_key_pressed(KEY_C):
		PlayerGlobalScript.modal_open = true
		message_input.visible = true
		send_button.visible = true
		global_message.visible = true
		global_message.add_theme_color_override("BG Color", "#727272")
	
func _on_send_button_pressed():
	if not message_input.text.is_empty():
		var user_send_message = user_send_message.duplicate()

		#"https://i.imgur.com/ajVzRmV.png"
		user_send_message.text = PlayerGlobalScript.player_name + ": " + message_input.text
		message_container.visible = true
		message_container.add_child(user_send_message)

		#await get_tree().process_frame

		#send the data to the backend
		SocketConnection.send_data({"Socket_Type": "globalMessage", "Sender": PlayerGlobalScript.player_name, "Message": message_input.text })
		
		message_input.text = ""
		PlayerGlobalScript.modal_open = false
		message_input.visible = false
		send_button.visible = false
		
		if PlayerGlobalScript.modal_open == false:
			await get_tree().create_timer(3.0).timeout
			global_message.visible = false

	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func receive_message(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "globalMessage":
			print(data)
			#TODO: work on this
			'''
			var instance_receive_container = recieve_message_container.duplicate()
			var receiver_name = instance_receive_container.get_node("Sender")
			var receiver_profile = instance_receive_container.get_node("Profile")
			var receive_message_text = instance_receive_container.get_node("Panel").get_node("Text Contents")
			
			http_request.request(receiver_profile)
			
			receiver_name.text = data.get("Sender")
			receive_message_text.text = data.get("Message")
			
			instance_receive_container.visible = true
			message_contents_container.add_child(instance_receive_container)
			'''
