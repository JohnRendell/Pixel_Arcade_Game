extends Node

func player_spawn():
	var playerName = PlayerGlobalScript.player_name
	var playerCoords = PlayerGlobalScript.playerCoords
	
	SocketConnection.send_data({
		"Socket_Type": "playerSpawn",
		"Player_Name": playerName,
		"isLeft": PlayerGlobalScript.isLeft,
		"isRight": PlayerGlobalScript.isRight,
		"isUp": PlayerGlobalScript.isUp,
		"isDown": PlayerGlobalScript.isDown,
		"isIdle": PlayerGlobalScript.isIdle,
		"Pos_X": playerCoords.x,
		"Pos_Y": playerCoords.y
	})
