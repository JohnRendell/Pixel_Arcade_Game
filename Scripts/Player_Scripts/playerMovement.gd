extends CharacterBody2D

@export var speed = 400
@onready var sprite = $Player_Sprite

func _physics_process(_delta):
	var playerPos = Vector2()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if PlayerGlobalScript.modal_open == false and PlayerGlobalScript.global_message_open == false and SocketConnection.connect_server_status == "Connected":
		if input_vector:
			velocity = input_vector * speed
			PlayerGlobalScript.isIdle = false
			
			#left
			if input_vector.x <= -1 and input_vector.y <= 0:
				PlayerGlobalScript.isLeft = true
				PlayerGlobalScript.isRight = false
				PlayerGlobalScript.isUp = false
				PlayerGlobalScript.isDown = false
				
				sprite.flip_h = true
			
			#right
			elif input_vector.x >= 1 and input_vector.y <= 0:
				PlayerGlobalScript.isLeft = false
				PlayerGlobalScript.isRight = true
				PlayerGlobalScript.isUp = false
				PlayerGlobalScript.isDown = false
				
				sprite.flip_h = false
			
			#back/down
			elif input_vector.y >= 1 and input_vector.x <= 0:
				PlayerGlobalScript.isLeft = false
				PlayerGlobalScript.isRight = false
				PlayerGlobalScript.isUp = false
				PlayerGlobalScript.isDown = true
				
				sprite.flip_h = false
			
			#front/up
			elif input_vector.y <= -1 and input_vector.x <= 0:
				PlayerGlobalScript.isLeft = false
				PlayerGlobalScript.isRight = false
				PlayerGlobalScript.isUp = true
				PlayerGlobalScript.isDown = false
				
				sprite.flip_h = false
		else:
			velocity = input_vector
			PlayerGlobalScript.isIdle = true
	move_and_slide()
	
	playerPos = self.position
	PlayerGlobalScript.playerCoords = playerPos
