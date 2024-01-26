class_name Bullet extends Node2D

@export var velocity = 900
@export var lifetime = 1.5 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = lifetime
	$Timer.timeout.connect(func(): self.queue_free())
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * velocity * delta


func _on_area_2d_body_entered(body: Node2D):
	# body is a PyhicsBody2D or a TileMap
	if body.is_in_group('Enemies'):
		body.hit_by_bullet()
	queue_free()
