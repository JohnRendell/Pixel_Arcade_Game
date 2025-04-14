extends Node2D

#particle
@onready var particle = $"Leaves Particle"

#modals
@onready var login_modal = $"Lobby UI/UI/Log in Modal"

#for loading panel
@export var loading_panel: Panel

func _ready():
	particle.emitting = true
	
	login_modal.visible = false
	PlayerGlobalScript.player_name = guest_player_name_generator()
	
	#scatter trees
	var tree = preload("res://Sprites/tree_object.tscn")
	var tree_pos = [Vector2(302, 278), Vector2(-385, -524), Vector2(899, -176), Vector2(-406, 719)]
	scatter_obj(tree, tree_pos)
	
	#scatter rocks
	var rock = preload("res://Sprites/rock_object.tscn")
	var rock_pos = [Vector2(500, 500), Vector2(762, 694), Vector2(472, -369)]
	scatter_obj(rock, rock_pos)
	
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

#for scattering ojects
func scatter_obj(obj, tree_pos):
	for pos in tree_pos:
		var instance = obj.instantiate()
		$"Y sort".add_child(instance)
		instance.position = pos

func _on_guest_button_pressed():
	loading_panel.visible = true
	SocketConnection.send_data({ "Socket_Type": "playerLeave_lobby", "Player_Name": PlayerGlobalScript.player_name })
	
	BackendStuff.send_data_to_express({ "playerCount": 1 }, "/gameData/setPlayerCount")
		
	await get_tree().create_timer(1.0).timeout
	if BackendStuff.returned_parsed["message"] == "success":
		loading_panel.begin_load = true
		PlayerGlobalScript.isLoggedIn = true
