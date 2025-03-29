extends CharacterBody2D

@export var speed = 400
@onready var sprite = $Player_Sprite

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector:
		velocity = input_vector * speed
		PlayerScript.isIdle = false
		
		#left
		if input_vector.x <= -1 and input_vector.y <= 0:
			PlayerScript.isLeft = true
			PlayerScript.isRight = false
			PlayerScript.isUp = false
			PlayerScript.isDown = false
			
			sprite.flip_h = true
		
		#right
		elif input_vector.x >= 1 and input_vector.y <= 0:
			PlayerScript.isLeft = false
			PlayerScript.isRight = true
			PlayerScript.isUp = false
			PlayerScript.isDown = false
			
			sprite.flip_h = false
		
		#back/down
		elif input_vector.y >= 1 and input_vector.x <= 0:
			PlayerScript.isLeft = false
			PlayerScript.isRight = false
			PlayerScript.isUp = false
			PlayerScript.isDown = true
			
			sprite.flip_h = false
		
		#front/up
		elif input_vector.y <= -1 and input_vector.x <= 0:
			PlayerScript.isLeft = false
			PlayerScript.isRight = false
			PlayerScript.isUp = true
			PlayerScript.isDown = false
			
			sprite.flip_h = false
	else:
		velocity = input_vector
		PlayerScript.isIdle = true
	move_and_slide()
