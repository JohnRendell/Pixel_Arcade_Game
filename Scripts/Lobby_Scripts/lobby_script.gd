extends Node2D

var playerUIInterface = preload("res://Interfaces/playerInfo.tscn").instantiate()

#buttons on the lobby
@onready var login_button = $"Lobby UI/CanvasLayer/Log in Button"

#modals
@onready var login_modal = $"Lobby UI/CanvasLayer/Log in Modal"

func _ready():
	get_tree().get_root().add_child(playerUIInterface)
	login_button.pressed.connect(open_login)

func open_login():
	PlayerGlobalScript.modal_open = true
	login_modal.visible = true
