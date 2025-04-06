extends Control

@export var login_warning_text: RichTextLabel
@export var login_username_input: LineEdit
@export var login_password_input: LineEdit
	
func _process(_delta: float):
	if !PlayerGlobalScript.modal_open:
		login_warning_text.text = ""

func _on_log_in_button_pressed():
	if !login_username_input.text or !login_password_input.text:
		login_warning_text.text = "Fields cannot be empty."
	
	else:
		BackendStuff.send_data_to_express({ "username": login_username_input.text, "password": login_password_input.text }, "/validate/login")
		
		#TODO: finish this one
		await get_tree().create_timer(1.0).timeout
		print("Get from request: " + str(BackendStuff.returned_parsed))
		print("Status: " + str(BackendStuff.returned_parsed["status"]))
