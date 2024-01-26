extends CharacterBody2D


const SPEED = 150.0
@onready var picture = $Picture

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player: Player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_direction = (player.global_position - global_position).normalized()
	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	picture.look_at(player.global_position)

	move_and_slide()
