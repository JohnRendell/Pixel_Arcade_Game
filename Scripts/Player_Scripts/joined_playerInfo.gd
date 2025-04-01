extends Node

@onready var player_anim = $joined_Player_Sprite/AnimationPlayer
@onready var player_name_text = $"Player Name"
@onready var player_character = $"."

@export var player_name = ""

@export var isLeft = false
@export var isRight = false
@export var isUp = false
@export var isDown = false
@export var isIdle = false

func _ready():
	player_anim.play("idle_front")
	player_name_text.text = player_name

func _process(_delta: float):
	$joined_Player_Sprite.flip_h = isLeft
	
	if isIdle:
		if isLeft or isRight:
			player_anim.play("idle_side")
		if isUp:
			player_anim.play("idle_back")
		if isDown:
			player_anim.play("idle_front")
	else:
		if isLeft or isRight:
			player_anim.play("walk_side")
		if isUp:
			player_anim.play("walk_back")
		if isDown:
			player_anim.play("walk_front")
