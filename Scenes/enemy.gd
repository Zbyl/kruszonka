extends CharacterBody2D

class_name Enemy

const SPEED = 150.0
const PUSH_BACK_DRAG = 50.0
const PUSH_BACK_INITIAL_VELOCITY = 400.0
const MIN_DISTANCE_TO_PLAYER = 80
@onready var picture = $Picture

var push_back_velocity: Vector2 = Vector2.ZERO

const BLOOD = preload("res://Scenes/blood.tscn")
@onready var blood_marker = $Picture/BloodMarker

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player: Player
var blood_container: Node2D

var health: int = 100
const PUNCH_DAMAGE = 40
const BULLET_DAMAGE = 34
const BOOMERANG_DAMAGE = 60

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	blood_container = get_tree().get_nodes_in_group("BloodContainer")[0]

func hit_by_boomerang():
	_on_hit(BOOMERANG_DAMAGE)

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

func _physics_process(delta):
	if push_back_velocity:
		velocity += push_back_velocity
		push_back_velocity.x = move_toward(push_back_velocity.x, 0, PUSH_BACK_DRAG)
		push_back_velocity.y = move_toward(push_back_velocity.y, 0, PUSH_BACK_DRAG)
		move_and_slide()
		return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var vec_to_player = player.global_position - global_position
	var move_direction = vec_to_player.normalized()
	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if vec_to_player.length() <= MIN_DISTANCE_TO_PLAYER:
		velocity = Vector2.ZERO
		global_position = player.global_position - move_direction * MIN_DISTANCE_TO_PLAYER

	picture.look_at(player.global_position)

	move_and_slide()
