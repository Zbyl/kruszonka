extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var minimap = get_tree().get_first_node_in_group("Minimap")
	minimap.tilemap = $NavigationRegion2D/TileMap
	minimap.camera = $Camera2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
