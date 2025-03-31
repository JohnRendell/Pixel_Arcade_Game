extends "res://Scripts/Player_Scripts/playerMovement.gd"
	
func _process(delta: float):
	var player_text = $"Player_Sprite/Player Name"
	player_text.text = PlayerGlobalScript.player_name
	GameSocket.player_spawn()
