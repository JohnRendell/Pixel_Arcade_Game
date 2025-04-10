extends Control

@export var send_message_container: Control
@export var recieve_message_container: Control
@export var message_input: TextEdit
@export var send_message_button: Button
@export var message_contents_container: VBoxContainer
@export var scroll_container: ScrollContainer

#http request for getting user profiles
@export var http_request: HTTPRequest

var image_rect: TextureRect

func _ready() -> void:
	pass

func _process(_delta: float):
	var socket_data = SocketConnection.socket_data
	receive_message(socket_data)

#TODO: make this work properly
func _on_send_button_pressed():
	if not message_input.text.is_empty():
		var instance_send_container = send_message_container.duplicate()
		var sender_name = instance_send_container.get_node("Sender")
		var sender_profile = instance_send_container.get_node("Profile")
		var sender_panel = instance_send_container.get_node("Panel")
		var send_message_text = sender_panel.get_node("Text Contents")

		#"https://i.imgur.com/ajVzRmV.png"
		send_message_text.text = message_input.text
		sender_name.text = PlayerGlobalScript.player_name + " (You)"
		
		instance_send_container.visible = true
		print("Before adding the instance container: " + str(instance_send_container.size))
		print("Before adding the panel container: " + str(sender_panel.size))
		
		message_contents_container.add_child(instance_send_container)

		await get_tree().process_frame
		instance_send_container.custom_minimum_size = sender_panel.size
				
		print("\nAfter adding the instance container: " + str(instance_send_container.size))
		print("After adding the panel container: " + str(sender_panel.size))
		
		#send the data to the backend
		SocketConnection.send_data({"Socket_Type": "globalMessage", "Sender": PlayerGlobalScript.player_name, "Message": message_input.text })
		
		message_input.text = ""

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
			


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == OK and response_code == 200:
		var image = Image.new()
		var error = image.load_png_from_buffer(body)
		if error == OK:
			var texture = ImageTexture.create_from_image(image)
			image_rect.texture = texture
		else:
			print("Error loading image from buffer:", error)
	else:
		print("HTTP request failed.")
