extends Node

var hud: Hud

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_tree().get_first_node_in_group('Hud')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
