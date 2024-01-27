extends Node

class_name Game

@onready var hud = $Hud
@onready var music = $Music
@onready var lost_sound = $LostSound
@onready var win_sound = $WinSound

const BAKERY = preload("res://Levels/bakery.tscn")
const GAME_LOST = preload("res://Scenes/game_lost.tscn")
const GAME_WON = preload("res://Scenes/game_won.tscn")

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.new_game_pressed.connect(_on_new_game_pressed)
	hud.exit_game_pressed.connect(_on_exit_game_pressed)
	hud.show_background(true)
	hud.show_menu(true)
	hud.show_weapons(false)
	
	music.play()	# @todo Make it loop somehow.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_new_game_pressed():
	hud._on_new_game()
	_switch_level(BAKERY, true)

func _switch_level(new_level_scene, show_weapons: bool):
	if level:
		level.queue_free()
		level = null

	# Hack to make sure we instantiate new level once old level is actually freed.
	# Otherwise we might have two Players at once etc.
	await get_tree().create_timer(0.01).timeout
		
	level = new_level_scene.instantiate()
	add_child(level)
	hud.show_background(false)
	hud.show_menu(false)
	hud.show_weapons(show_weapons)

func _on_exit_game_pressed():
	get_tree().quit()

func _on_player_lost():
	pause_player_and_enemies(true)
	lost_sound.play()
	await lost_sound.finished
	await get_tree().create_timer(1.0).timeout
	_switch_level(GAME_LOST, false)

func _on_player_won():
	pause_player_and_enemies(true)
	win_sound.play()
	await win_sound.finished
	await get_tree().create_timer(1.0).timeout
	_switch_level(GAME_WON, false)

func pause_player_and_enemies(do_pause: bool):
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.pause(do_pause)
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.pause(do_pause)
	
