extends Node

@export var diamond: RichTextLabel
var diamondCount = 0

func _ready():
	#check for player info
	if PlayerGlobalScript.player_username:
		BackendStuff.send_data_to_express({ "username": PlayerGlobalScript.player_username }, "/playerInfo")
		
		await get_tree().create_timer(1.0).timeout
		PlayerGlobalScript.player_name = BackendStuff.returned_parsed["inGameName"]
		diamondCount = BackendStuff.returned_parsed["diamondCount"]
		
	diamond.text = str(diamondCount)
	
func _process(_delta: float):
	pass
