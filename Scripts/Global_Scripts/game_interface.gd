extends Control

@onready var playerTextCoordsLabel = $"Player Coordinates"

func _process(_delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]
