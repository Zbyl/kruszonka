extends CharacterBody2D

class_name Enemy

const SPEED = 150.0
const PUSH_BACK_DRAG = 50.0
const PUSH_BACK_INITIAL_VELOCITY = 400.0
const MIN_DISTANCE_TO_PLAYER = 80	# Enemy will be pushed away from the Player if it is too close.
@onready var picture = $Picture

var push_back_velocity: Vector2 = Vector2.ZERO

const BLOOD = preload("res://Scenes/blood.tscn")
@onready var blood_marker = $Picture/BloodMarker

@onready var navigation_agent = $Navigation/NavigationAgent2D
@export var navigation_target: Node2D
const TARGET_REACHED_DISTANCE = 10 	# Enemy will consider it reached navigation_target when it is this close.

@onready var animation_player = $Picture/AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player: Player
var blood_container: Node2D

var health: float = 100.0
var last_boomerang_hit = -1000000
const PUNCH_DAMAGE = 40
const BULLET_DAMAGE = 34
const BOOMERANG_DAMAGE = 60
const BOOMERANG_IMMUNE_TIME = 300

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	blood_container = get_tree().get_first_node_in_group("BloodContainer")

func hit_by_boomerang():
	if Time.get_ticks_msec() >= last_boomerang_hit + BOOMERANG_IMMUNE_TIME: 
		_on_hit(BOOMERANG_DAMAGE)
		last_boomerang_hit = Time.get_ticks_msec()

func hit_by_bullet():
	_on_hit(BULLET_DAMAGE)

func push_back_by_player(punch_power: float):
	var dir_to_player = (player.global_position - global_position).normalized()
	push_back_velocity = -dir_to_player * PUSH_BACK_INITIAL_VELOCITY * punch_power
	_on_hit(punch_power * PUNCH_DAMAGE)

func _on_hit(damage: float):
	var blood = BLOOD.instantiate()
	blood_container.add_child(blood)
	blood.global_position = blood_marker.global_position
	blood.rotation = picture.rotation + PI
	
	health -= damage
	if health <= 0:
		queue_free()

func _physics_process(_delta):
	if push_back_velocity:
		velocity += push_back_velocity
		push_back_velocity.x = move_toward(push_back_velocity.x, 0, PUSH_BACK_DRAG)
		push_back_velocity.y = move_toward(push_back_velocity.y, 0, PUSH_BACK_DRAG)
		move_and_slide()
		return
		
	var move_direction = Vector2.ZERO
	var vec_to_player = player.global_position - global_position
	if navigation_target:
		# We are following a path.
		var vec_to_target = navigation_agent.get_next_path_position() - global_position
		if vec_to_target.length() <= TARGET_REACHED_DISTANCE:
			move_direction = Vector2.ZERO
			print('Target reached')
		else:
			move_direction = vec_to_target.normalized()
			print('Following target')
	else:
		# We are going straight for the player.
		# @todo If distance is large we don't want to follow player.
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		move_direction = vec_to_player.normalized()

	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity:
		animation_player.play("walk")
	else:
		animation_player.play("idle")

	# Push back enemy if too close to the player. Otherwise enemy sticks to the player.
	# @todo Warning: Causes enemy to tunnel through walls.
	if vec_to_player.length() <= MIN_DISTANCE_TO_PLAYER:
		velocity = Vector2.ZERO
		global_position = player.global_position - move_direction * MIN_DISTANCE_TO_PLAYER

	# Rotate picture of the enemy to look at the player.
	# We don't rotate the whole enemy beause collition detection works weirdly then.
	picture.look_at(player.global_position)

	move_and_slide()


func _on_navigation_timer_timeout():
	if not navigation_target:
		return
		
	navigation_agent.target_position = navigation_target.global_position
