extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var look_direction = Input.get_vector("rotate_left", "rotate_right", "rotate_up", "rotate_down")
	look_direction = Vector2(-look_direction.y, look_direction.x)
	#print("move_direction", move_direction)
	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if look_direction:
		look_at(global_position + look_direction)

	move_and_slide()