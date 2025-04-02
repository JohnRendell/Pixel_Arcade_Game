extends Node

@onready var anim = $spawner/AnimationPlayer

@export var isSpawn = false

func _process(_delta: float):
	if isSpawn:
		anim.play("Spawn")
	else:
		anim.play("Stationary")


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "Spawn":
		isSpawn = false
