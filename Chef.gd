extends Node2D

@onready var picture = $Picture
var player: Player
var enemy_container: Node2D
const LOOK_AT_PLAYER_DISTANCE = 64 * 5
const SPEAK_DISTANCE = 64 * 5
var can_speak: bool = true
@export var is_wizard: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	enemy_container = get_tree().get_first_node_in_group("EnemyContainer")
	$Cooldown.timeout.connect(func(): self.can_speak = true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Rotate picture of the enemy to look at the player.
	# We don't rotate the whole enemy beause collition detection works weirdly then.
	var vec_to_player = player.global_position - global_position
	if vec_to_player.length() < LOOK_AT_PLAYER_DISTANCE:
		picture.look_at(player.global_position)
		
	if not is_wizard:
		if vec_to_player.length() < SPEAK_DISTANCE:
			if can_speak and Input.is_action_just_pressed("action"):
				GameData.game.pause_player_and_enemies(true)
				can_speak = false
				Dialogic.timeline_ended.connect(_dialog_ended)
				Dialogic.start("hello")
			

func _dialog_ended():
	Dialogic.timeline_ended.disconnect(_dialog_ended)
	GameData.game.pause_player_and_enemies(false)
	$Cooldown.start()
	GameData.hud.allow_croissant()


func _wizard_dialog_ended():
	Dialogic.timeline_ended.disconnect(_wizard_dialog_ended)
	GameData.game.pause_player_and_enemies(false)
	$Cooldown.start()


func _on_area_2d_body_entered(body):
	if is_wizard:
		if can_speak:
			GameData.game.pause_player_and_enemies(true)
			can_speak = false
			Dialogic.timeline_ended.connect(_wizard_dialog_ended)
			Dialogic.start("wizard")
