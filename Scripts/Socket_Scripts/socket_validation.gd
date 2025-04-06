extends Control

#connecting to server modal
@export var connect_server_modal_path: NodePath

@onready var connect_server_modal = get_node(connect_server_modal_path)
@onready var connect_server_modal_anim = connect_server_modal.get_node("Panel/Sprite Display/AnimationPlayer")
@onready var connect_server_modal_retry_btn = connect_server_modal.get_node("Panel/Retry_btn")
@onready var connect_server_modal_label = connect_server_modal.get_node("Panel/Label")

var isDisconnect = false

func _ready():
	#for no connection stuff
	_on_animation_player_animation_finished("disconnect_anim")

func _process(_delta: float):
	#for modal
	if SocketConnection.connect_server_status == "Unable to Connect with the Server" and isDisconnect == false:
		isDisconnect = true
		connect_server_modal_anim.play("disconnect_anim")
		
	if SocketConnection.connect_server_status == "Connecting to Server...":
		isDisconnect = false
		connect_server_modal_anim.play("connecting_anim")
	
	connect_server_modal.visible = false if SocketConnection.connect_server_status == "Connected" else true
	connect_server_modal_label.text = SocketConnection.connect_server_status
	connect_server_modal_retry_btn.visible = true if SocketConnection.connect_server_status == "Unable to Connect with the Server" else false
	
func _on_retry_btn_button_down():
	await SocketConnection.reconnect_to_server()

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "disconnect_anim" and isDisconnect:
		connect_server_modal_anim.play("no_connection_anim")
