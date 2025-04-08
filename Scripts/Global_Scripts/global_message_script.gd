extends Control

@export var send_message_container: Panel
@export var recieve_message_container: Panel
@export var message_input: TextEdit
@export var send_message_button: Button
@export var message_contents_container: VBoxContainer
@export var scroll_container: ScrollContainer

func _on_send_button_pressed():
	if not message_input.text.is_empty():
		var instance_send_container = send_message_container.duplicate()
		var send_message_text = instance_send_container.get_node("Text Contents")
		send_message_text.text = message_input.text
		
		instance_send_container.visible = true
		message_contents_container.add_child(instance_send_container)
		message_input.text = ""

	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
