extends Node

@onready var loading_panel = $"Loading Panel"

func _ready():
	loading_panel.visible = false

func _on_play_button_pressed():
	loading_panel.visible = true
	loading_panel.begin_load = true
