extends Node2D

var playerUIInterface = preload("res://Interfaces/playerInfo.tscn").instantiate()

#buttons on the lobby
@onready var login_button = $"Lobby UI/CanvasLayer/Log in Button"

#modals
@onready var login_modal = $"Lobby UI/CanvasLayer/Log in Modal"

func _ready():
	get_tree().get_root().add_child(playerUIInterface)
	login_button.pressed.connect(open_login)
	
	PlayerGlobalScript.player_name = guest_player_name_generator()
	
func _process(delta: float):
	var socket_data = SocketConnection.socket_data
	check_for_players(socket_data)

func open_login():
	PlayerGlobalScript.modal_open = true
	login_modal.visible = true
	
func guest_player_name_generator():
	var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
	"m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	var nums = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	
	var randomNum = RandomNumberGenerator.new()
	var name = ""
	
	for i in range(2):
		var char_index = randomNum.randi_range(0, len(letters) - 1)
		var num_index = randomNum.randi_range(0, len(nums) - 1)
		
		var temp_name = "%s%s" % [letters[char_index], nums[num_index]]
		name += temp_name
	
	return "Guest_%s" % [name]

func check_for_players(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "playerSpawn":
			var player_name = data.get("Player_Name")
			var player_posX = data.get("Pos_X")
			var player_posY = data.get("Pos_Y")
			
			print(player_name)
