extends Node2D

class_name BoomerangWeapon


@export var player: NodePath

const projectile = preload("res://Scenes/croissant_path.tscn")

var path = null

var activated = false	# True if weapon is currently active.


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

	

func activate(should_activate: bool):
	if should_activate:
		self.visible = true
		activated = true
	else:
		self.visible = false
		activated = false


func try_shoot():
	if activated and not is_instance_valid(path):
		path = projectile.instantiate()
		path.player = get_node(player).get_path()
		get_tree().root.add_child(path)
		path.global_position = self.global_position
		path.global_rotation = self.global_rotation
		#path.tree_exiting.connect(func(): $CatchSound.play())
