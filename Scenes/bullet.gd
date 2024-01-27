class_name Bullet extends Node2D

@export var velocity = 900
@export var lifetime = 1.5 
@export var kills_player: bool = false
var smoke_container
const BULLET_SMOKE = preload("res://Scenes/bullet_smoke.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	smoke_container = get_tree().get_first_node_in_group("SmokeContainer")
	$Timer.wait_time = lifetime
	$Timer.timeout.connect(func(): self.queue_free())
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * velocity * delta


func _on_area_2d_body_entered(body: Node2D):
	# body is a PyhicsBody2D or a TileMap
	if kills_player and body.is_in_group('Player'):
		body.hit_by_bullet(self)
	elif (not kills_player) and body.is_in_group('Enemies'):
		body.hit_by_bullet()
	else:
		var effect = BULLET_SMOKE.instantiate()
		effect.rotation = rotation + PI/2
		effect.global_position = global_position
		smoke_container.add_child(effect)
		
	queue_free()
