extends Node


func get_playerCount_status():
	BackendStuff.get_data_from_backend("/gameData/getPlayerCount")
	
	#TODO: investigate this one
	await get_tree().create_timer(1.0).timeout
	if BackendStuff.returned_parsed["status"] == "success":
		return str(int(BackendStuff.returned_parsed["playerCount"]))
	else:
		return "failed to fetch player count"
	
func set_playerCount_status(count):
	BackendStuff.send_data_to_express({ "playerCount": count }, "/gameData/setPlayerCount")
		
	await get_tree().create_timer(1.0).timeout
	return BackendStuff.returned_parsed["message"]
