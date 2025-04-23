extends Node

func _ready():
	PlayerGlobalScript.current_scene = "player_base"
	
	var tree = preload("res://Sprites/sand_tree_object.tscn")
	scatter_obj(tree, [Vector2(301, 145), Vector2(68, -690), Vector2(780, 14), Vector2(-1272, -557), Vector2(1522, 374)])
	
	SocketConnection.send_data({ "Socket_Type": "playerGoing", "Player_ID": PlayerGlobalScript.player_ID_name })

#for scattering ojects
func scatter_obj(obj, tree_pos):
	for pos in tree_pos:
		var instance = obj.instantiate()
		$"Ysort".add_child(instance)
		instance.position = pos
