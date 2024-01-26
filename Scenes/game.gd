extends Node

const BAKERY = preload("res://Levels/bakery.tscn")

var level

# Called when the node enters the scene tree for the first time.
func _ready():
	level = BAKERY.instantiate()
	add_child(level)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
