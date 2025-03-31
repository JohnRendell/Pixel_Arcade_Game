extends Node

func player_spawn():
	var playerName = PlayerGlobalScript.player_name
	var playerCoords = PlayerGlobalScript.playerCoords
	
	SocketConnection.send_data({
		"Socket_Type": "playerSpawn",
		"Player_Name": playerName,
		"Pos_X": playerCoords.x,
		"Pos_Y": playerCoords.y
	})
