extends Node

@onready var player_anim = $AnimationPlayer
@onready var player_name = $"Player Name"

func _ready():
	player_anim.play("idle_front")
