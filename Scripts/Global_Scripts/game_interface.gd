extends Control

@onready var playerTextCoordsLabel = $"Player Coordinates"
@onready var playerSettings = $"Setting Button"
@onready var loading_panel = $"Loading Panel"
@onready var setting_modal = $"Setting Modal"
@onready var playerCount = $"Player Count"

var isPlayerCountFetch = false

func _ready():
	playerSettings.visible = true if PlayerGlobalScript.isLoggedIn else false
	print(PlayerGlobalScript.player_name)
	loading_panel.visible = false

func _process(_delta: float):
	var playerX = PlayerGlobalScript.playerCoords.x
	var playerY = PlayerGlobalScript.playerCoords.y
	
	playerTextCoordsLabel.text = "X: %.2f \nY: %.2f " % [playerX, playerY]
	
	var socket_data = SocketConnection.socket_data
	player_count(socket_data)
	
	if SocketConnection.connect_server_status == "Connected" and isPlayerCountFetch == false:
		BackendStuff.get_data_from_backend("/gameData/getPlayerCount")
		
		isPlayerCountFetch = true
		await get_tree().create_timer(1.0).timeout
		if BackendStuff.returned_parsed["message"] == "success":
			playerCount.text = "Player Count: " + str(int(BackendStuff.returned_parsed["playerCount"]))
			
			await get_tree().create_timer(1.0).timeout
			SocketConnection.send_data({ "Socket_Type": "playerCount", "Player_Count": BackendStuff.returned_parsed["playerCount"] })
	
func player_count(data):
	if typeof(data) == TYPE_DICTIONARY:
		if data.get("Socket_Type") == "playerCount":
			print("Get data from player count: " + str(int(data.get("Player_Count"))))
			playerCount.text = "Player Count: " + str(int(data.get("Player_Count")))


func _on_log_out_button_pressed():
	loading_panel.visible = true
	setting_modal.visible = false
	BackendStuff.send_data_to_express({ "playerCount": -1 }, "/gameData/setPlayerCount")
		
	await get_tree().create_timer(1.0).timeout
	if BackendStuff.returned_parsed["message"] == "success":

		await get_tree().create_timer(1.0).timeout
		loading_panel.begin_load = true
		
		PlayerGlobalScript.modal_open = false
		PlayerGlobalScript.isLoggedIn = false
