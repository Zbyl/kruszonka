extends CharacterBody2D

class_name Bunny

@onready var picture = $Picture

const SPEED = 350.0
const ACTIVATION_DISTANCE = 3 * 64
const FOLLOW_DISTANCE = 15 * 64
const MIN_DISTANCE_TO_PLAYER = 1 * 64

var player: Player
var follow_activated: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
	var move_direction = Vector2.ZERO
	var vec_to_player = player.global_position - global_position

	# We are going straight for the player.
	# @todo If distance is large we don't want to follow player.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if vec_to_player.length() < ACTIVATION_DISTANCE:
		follow_activated = true
	if follow_activated and (vec_to_player.length() < FOLLOW_DISTANCE):
		move_direction = vec_to_player.normalized()

	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Stop if too close to the player.
	if vec_to_player.length() <= MIN_DISTANCE_TO_PLAYER:
		velocity = Vector2.ZERO

	# Rotate picture of the enemy to look at the player.
	# We don't rotate the whole enemy beause collition detection works weirdly then.
	picture.look_at(player.global_position)

	move_and_slide()
