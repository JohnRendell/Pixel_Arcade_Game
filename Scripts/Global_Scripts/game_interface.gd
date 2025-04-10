extends Control

@onready var playerTextCoordsLabel = $"Player Coordinates"
@onready var global_message_button = $"Global Messages"

func _ready():
	pass

func _process(_delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]
