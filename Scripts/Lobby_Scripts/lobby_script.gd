extends Node2D

var playerUIInterface = preload("res://Interfaces/playerInfo.tscn").instantiate()

#guest player name
@onready var guest_player_name = $"CanvasLayer/Main Player/Player Name"

#buttons on the lobby
@onready var login_button = $"Lobby UI/CanvasLayer/Log in Button"

#modals
@onready var login_modal = $"Lobby UI/CanvasLayer/Log in Modal"

func _ready():
	get_tree().get_root().add_child(playerUIInterface)
	login_button.pressed.connect(open_login)
	
	guest_player_name.text = guest_player_name_generator()

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
