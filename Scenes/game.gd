extends Node

class_name Game

@onready var hud = $Hud
@onready var music = $Music

const BAKERY = preload("res://Levels/bakery.tscn")

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.new_game_pressed.connect(_on_new_game_pressed)
	hud.exit_game_pressed.connect(_on_exit_game_pressed)
	hud.show_background(true)
	hud.show_menu(true)
	hud.show_weapons(false)
	
	music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_new_game_pressed():
	if level:
		level.queue_free()
		level = null

	# Hack to make sure we instantiate new level once old level is actually freed.
	# Otherwise we might have two Players at once etc.
	await get_tree().create_timer(0.01).timeout
		
	level = BAKERY.instantiate()
	add_child(level)
	hud.show_background(false)
	hud.show_menu(false)
	hud.show_weapons(true)

func _on_exit_game_pressed():
	get_tree().quit()
