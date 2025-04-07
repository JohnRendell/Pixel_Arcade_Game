extends Node

@export var navigate_to_scene: String = "path of the scene"
@export var loading_panel: Panel

func _ready():
	loading_panel.visible = false

func _on_pressed():
	loading_panel.visible = true
	
	if navigate_to_scene:
		await get_tree().create_timer(1.0).timeout
		loading_panel.visible = false
		get_tree().change_scene_to_file(navigate_to_scene)
	else:
		print("No scene assigned")
