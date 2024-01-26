extends RigidBody2D

const SPEED = 100

var player: Player

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	var player_position = player.global_position
	var enemy_position = global_position
	linear_velocity = player_position - enemy_position
	linear_velocity = linear_velocity.normalized()

	var motion = linear_velocity * SPEED * delta
	move_and_collide(motion)
