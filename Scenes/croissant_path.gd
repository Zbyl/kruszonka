extends Node2D

@export var player: NodePath:
	set(a):
		player = a
		_player = get_node(player)
@onready var _player: Player = get_node(player)
@export var lifetime = 1.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Path.curve.set_point_position(2, (_player.global_position - global_position).rotated(-global_rotation))
	var next = $Path/PathFollow2D.progress_ratio + delta/lifetime
	if next >= 1.0:
		queue_free()
	else:
		$Path/PathFollow2D.progress_ratio = next
	
	$Path/PathFollow2D/Croissant.rotation += 4*PI*delta
