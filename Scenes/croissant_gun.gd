extends Node2D

@export var player: NodePath

const projectile = preload("res://Scenes/croissant_path.tscn")

var path = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("punch") and not is_instance_valid(path):
		path = projectile.instantiate()
		path.player = get_node(player).get_path()
		get_tree().root.add_child(path)
		path.global_position = self.global_position
		path.global_rotation = self.global_rotation
