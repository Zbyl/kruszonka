extends CharacterBody2D

class_name Bunny

@onready var picture = $Picture

const SPEED = 350.0
const ACTIVATION_DISTANCE = 3 * 64
#const FOLLOW_DISTANCE = 15 * 64
const MIN_DISTANCE_TO_PLAYER = 1 * 64

var player: Player
var follow_activated: bool = false

@onready var navigation_agent = $Navigation/NavigationAgent2D
@export var navigation_target: Node2D


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	# Set Player as the target and update navigation.
	await get_tree().physics_frame
	await get_tree().physics_frame
	navigation_target = player
	_on_navigation_timer_timeout()
	
	var minimap = get_tree().get_first_node_in_group("Minimap")
	minimap.trace(self, Color.SPRING_GREEN)

func _physics_process(_delta):
	var move_direction = Vector2.ZERO
	var vec_to_player = player.global_position - global_position

	$PlayerRaycast.target_position = vec_to_player
	$PlayerRaycast.force_raycast_update()
		
	var vec_to_target = vec_to_player

	# We are going straight for the player.
	# @todo If distance is large we don't want to follow player.
	
	if navigation_target:
		# We are following a path.
		vec_to_target = navigation_agent.get_next_path_position() - global_position

	# Sometimes vec_to_target is zero, when it shouldn't be. Hacking it.
	if (not follow_activated) and (vec_to_player.length() < ACTIVATION_DISTANCE) and ($PlayerRaycast.get_collider() == player):
		follow_activated = true
		$PickSound.play()
		print('follow_activated')
	if follow_activated: #and (vec_to_target.length() < FOLLOW_DISTANCE):
		move_direction = vec_to_target.normalized()

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

func _on_navigation_timer_timeout():
	if not navigation_target:
		return
		
	navigation_agent.target_position = navigation_target.global_position
