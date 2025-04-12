extends Node2D

#particle
@onready var particle = $"Leaves Particle"

#modals
@onready var login_modal = $"Lobby UI/UI/Log in Modal"

#preload player assets
var player_scene = preload("res://Sprites/player_2.tscn")

#objects on the lobby
@onready var spawner = $"Y sort/spawner"

#dictionary for joined players
@export var joined_players = {}

#for loading panel
@export var loading_panel: Panel

func _ready():
	particle.emitting = true
	
	login_modal.visible = false
	PlayerGlobalScript.player_name = guest_player_name_generator()
	
	#scatter trees
	var tree = preload("res://Sprites/tree_object.tscn")
	var tree_pos = [Vector2(302, 278), Vector2(-385, -524), Vector2(899, -176), Vector2(1485, 566), Vector2(-406, 719)]
	scatter_obj(tree, tree_pos)
	
	#scatter rocks
	var rock = preload("res://Sprites/rock_object.tscn")
	var rock_pos = [Vector2(500, 500), Vector2(762, 694), Vector2(472, -369)]
	scatter_obj(rock, rock_pos)
	
func _process(_delta: float):
	var socket_data = SocketConnection.socket_data
	check_for_players(socket_data)
	
func guest_player_name_generator():
	var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
	"m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	var nums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	
	var randomNum = RandomNumberGenerator.new()
	var playerName : String = ""
	
	for i in range(2):
		var char_index = randomNum.randi_range(0, len(letters) - 1)
		var num_index = randomNum.randi_range(0, len(nums) - 1)
		
		var temp_name = "%s%s" % [letters[char_index], nums[num_index]]
		playerName += temp_name
	
	return "Guest_%s" % [playerName]

func check_for_players(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "playerSpawn":
			var player_name = data.get("Player_Name")
			var player_posX = data.get("Pos_X")
			var player_posY = data.get("Pos_Y")
		
			#player status
			var isLeft = data.get("isLeft")
			var isRight = data.get("isRight")
			var isUp = data.get("isUp")
			var isDown = data.get("isDown")
			var isIdle = data.get("isIdle")
			
			#set up variables on joined player
			var player_join = player_scene.instantiate()
			
			#fill player's data
			player_join.player_name = player_name
				
			#spawn the player
			if PlayerGlobalScript.player_name != player_name:
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
					$"Y sort".add_child(player_join)
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
		
		elif data.get("Socket_Type") == "playerDisconnect":
			var player_name = data.get("Player_Name")
			
			if joined_players.has(player_name):
				var player = joined_players[player_name]
				player["Player"].queue_free()
				joined_players.erase(player_name)

#for scattering ojects
func scatter_obj(obj, tree_pos):
	for pos in tree_pos:
		var instance = obj.instantiate()
		$"Y sort".add_child(instance)
		instance.position = pos

func _on_guest_button_pressed():
	loading_panel.visible = true
	loading_panel.begin_load = true
