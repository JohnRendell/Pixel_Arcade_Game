extends Node

#dictionary for joined players
@export var joined_players = {}

#preload player assets
var player_scene = preload("res://Sprites/player_2.tscn")

#objects on the lobby
@export var spawner: StaticBody2D

#Y sort for placing players
@export var ySort: Node2D

#name of the scene to be spawned in
@export var scene_name = "name of the scene"

func _process(_delta: float):
	if PlayerGlobalScript.current_scene == "lobby" && PlayerGlobalScript.isLoggedIn == false:
		player_spawn(scene_name)
		
	var socket_data = SocketConnection.socket_data
	check_for_players(socket_data)

func check_for_players(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "playerSpawn_" + scene_name:
			var player_name = data.get("Player_Name")
			var player_posX = data.get("Pos_X")
			var player_posY = data.get("Pos_Y")
		
			#player status
			var isLeft = data.get("isLeft")
			var isRight = data.get("isRight")
			var isUp = data.get("isUp")
			var isDown = data.get("isDown")
			var isIdle = data.get("isIdle")
			
			#player scene
			var current_scene = data.get("Current_Scene")
			
			#set up variables on joined player
			var player_join = player_scene.instantiate()
			
			#fill player's data
			player_join.player_name = player_name
				
			#spawn the player
			if PlayerGlobalScript.player_name != player_name and current_scene == scene_name:
				if not joined_players.has(player_name):
					
					#activate the spawner machine status
					if !spawner.isSpawn:
						spawner.isSpawn = true
					
					player_join.position = Vector2(player_posX, player_posY)
				
					#player status
					player_join.isLeft = isLeft
					player_join.isRight = isRight
					player_join.isUp = isUp
					player_join.isDown = isDown
					player_join.isIdle = isIdle
				
					#add the player to the dict
					joined_players[player_name] = {
						"Player": player_join,
						"Position": Vector2(player_posX, player_posY)
					}
					ySort.add_child(player_join)
				else:
					var player = joined_players[player_name]
					player["Position"] = Vector2(player_posX, player_posY)
					player["Player"].position = Vector2(player_posX, player_posY)
				
					#player status
					player["Player"].isLeft = isLeft
					player["Player"].isRight = isRight
					player["Player"].isUp =  isUp
					player["Player"].isDown = isDown
					player["Player"].isIdle = isIdle
			
		elif data.get("Socket_Type") == "playerDisconnected" or (data.get("Socket_Type") == "playerGoing" and data.get("current_scene") != scene_name):
			var player_name = data.get("Player_Name")
			
			if joined_players.has(player_name):
				var player = joined_players[player_name]
				player["Player"].queue_free()
				joined_players.erase(player_name)

func player_spawn(_scene_name):
	var playerName = PlayerGlobalScript.player_name
	var playerCoords = PlayerGlobalScript.playerCoords
	
	SocketConnection.send_data({
		"Socket_Type": "playerSpawn_" + _scene_name,
		"Player_Name": playerName,
		"isLeft": PlayerGlobalScript.isLeft,
		"isRight": PlayerGlobalScript.isRight,
		"isUp": PlayerGlobalScript.isUp,
		"isDown": PlayerGlobalScript.isDown,
		"isIdle": PlayerGlobalScript.isIdle,
		"Pos_X": playerCoords.x,
		"Pos_Y": playerCoords.y,
		"Current_Scene": PlayerGlobalScript.current_scene
	})
