extends Sprite2D

@onready var anim = $Player_Anim

func _ready():
	anim.play("Idle_Front")

func _process(delta):
	if PlayerGlobalScript.isIdle:
		if PlayerGlobalScript.isLeft or PlayerGlobalScript.isRight:
			anim.play("Idle_Side")
			
		if PlayerGlobalScript.isDown:
			anim.play("Idle_Front")
			
		if PlayerGlobalScript.isUp:
			anim.play("Idle_Back")
	else:
		if PlayerGlobalScript.isLeft or PlayerGlobalScript.isRight:
			anim.play("Walk_Side")
			
		if PlayerGlobalScript.isDown:
			anim.play("Walk_Front")
			
		if PlayerGlobalScript.isUp:
			anim.play("Walk_Back")
