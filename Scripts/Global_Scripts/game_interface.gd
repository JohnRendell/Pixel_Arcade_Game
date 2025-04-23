extends Control

@onready var playerTextCoordsLabel = $"Player Coordinates"
@onready var playerSettings = $"Setting Button"
@onready var loading_panel = $"Loading Panel"
@onready var setting_modal = $"Setting Modal"
@onready var playerCount = $"Player Count"
@onready var playerProfile = $"Profile UI"

var db_playerCount = 0

func _ready():
	playerSettings.visible = true if PlayerGlobalScript.isLoggedIn else false
	playerProfile.visible = true if PlayerGlobalScript.isLoggedIn else false
	loading_panel.visible = false
	
	#get playercount
	playerCount.text = "Player Count: " + await BackendComponents.get_playerCount_status()

func _process(_delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]
	
	var socket_data = SocketConnection.socket_data
	player_count(socket_data)
	
func player_count(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "playerCount":
			playerCount.text = "Player Count: " + str(int(data.get("Player_Count")))

func _on_log_out_button_pressed():
	loading_panel.visible = true
	setting_modal.visible = false
	playerProfile.visible = false
	
	if await BackendComponents.set_playerCount_status(-1) == "success":
		loading_panel.begin_load = true
		
		PlayerGlobalScript.modal_open = false
		PlayerGlobalScript.isLoggedIn = false
