extends Node2D

@onready var picture = $Picture
var player: Player
const LOOK_AT_PLAYER_DISTANCE = 64 * 5

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate picture of the enemy to look at the player.
	# We don't rotate the whole enemy beause collition detection works weirdly then.
	var vec_to_player = player.global_position - global_position
	if vec_to_player.length() < LOOK_AT_PLAYER_DISTANCE:
		picture.look_at(player.global_position)
