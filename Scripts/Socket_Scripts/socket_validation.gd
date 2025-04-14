extends Control

#connecting to server modal
@onready var connect_server_modal = $"."
@onready var connect_server_modal_anim = $"Panel/Sprite Display/AnimationPlayer"
@onready var connect_server_modal_retry_btn = $"Panel/Retry_btn"
@onready var connect_server_modal_label = $"Panel/Label"

var isDisconnect = false
var isConnected = false
var isNotifFired = false

func _ready():
	#for no connection stuff
	_on_animation_player_animation_finished("disconnect_anim")
	
	NotificationManager.connect("notify_connected", self._on_notify_connected)

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
	isConnected = true if SocketConnection.connect_server_status == "Connected" else false
	
	if isConnected and isNotifFired == false:
		NotificationManager.player_connected(PlayerGlobalScript.player_name)
		isNotifFired = true

func _on_notify_connected(playername):
	SocketConnection.send_data({"Socket_Type": "playerConnected", "Player_Name": playername })
	
func _on_retry_btn_button_down():
	await SocketConnection.reconnect_to_server()

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "disconnect_anim" and isDisconnect:
		connect_server_modal_anim.play("no_connection_anim")
