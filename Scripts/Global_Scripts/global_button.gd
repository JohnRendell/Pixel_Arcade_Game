extends Node

@export var navigate_to_scene: String = "path of the scene"

func _on_pressed():
	if navigate_to_scene:
		get_tree().change_scene_to_file(navigate_to_scene)
	else:
		print("No scene assigned")
