extends Control

@onready var playerTextCoordsLabel = $"Player Coordinates"
@onready var global_message_button = $"Global Messages"
@onready var global_message_modal = $"Global Message Modal"

func _ready():
	global_message_modal.visible = false

func _process(_delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]

func _on_global_messages_button_down():
	global_message_modal.visible = true
	PlayerGlobalScript.modal_open = true
