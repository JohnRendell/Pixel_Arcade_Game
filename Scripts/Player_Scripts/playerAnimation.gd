extends Sprite2D

@onready var anim = $Player_Anim

func _process(delta):
	if PlayerScript.isIdle:
		if PlayerScript.isLeft or PlayerScript.isRight:
			anim.play("Idle_Side")
			
		if PlayerScript.isDown:
			anim.play("Idle_Front")
			
		if PlayerScript.isUp:
			anim.play("Idle_Back")
	else:
		if PlayerScript.isLeft or PlayerScript.isRight:
			anim.play("Walk_Side")
			
		if PlayerScript.isDown:
			anim.play("Walk_Front")
			
		if PlayerScript.isUp:
			anim.play("Walk_Back")
