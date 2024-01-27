extends Node2D

@export var player: NodePath
@onready var _player: Player = get_node(player)
@export var lifetime = 0.8
@export var speed_curve: Curve

static var max_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	max_id += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var progress = $Path/PathFollow2D.progress_ratio
	var rel_player_pos = (_player.global_position - global_position).rotated(-global_rotation)
	$Path.curve.set_point_position(2, rel_player_pos.lerp(Vector2.ZERO, 1-progress))
	
	var player_proximity_mult = _player.global_position.distance_to($Path/PathFollow2D.global_position)/500 # approx. max range
	print(player_proximity_mult)
	var next = progress + delta/lifetime * speed_curve.sample(clamp(player_proximity_mult, 0.0, 1.0))
	if next >= 1.0:
		queue_free()
	else:
		$Path/PathFollow2D.progress_ratio = next
	
	$Path/PathFollow2D/Croissant.rotation += 4*PI*delta


func _on_croissant_body_entered(body: Node2D):
	# body is a PyhicsBody2D or a TileMap
	if body.is_in_group('Enemies'):
		body.hit_by_boomerang()
		
		#queue_free()
