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
