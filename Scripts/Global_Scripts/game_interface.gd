extends Control

@onready var playerTextCoordsLabel = $"CanvasLayer/Player Coordinates"

func _process(delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]
