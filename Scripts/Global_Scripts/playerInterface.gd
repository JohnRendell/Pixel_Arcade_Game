extends Node2D

var playerUIInterface = preload("res://Interfaces/playerInfo.tscn").instantiate()

func _ready():
	get_tree().get_root().add_child(playerUIInterface)
