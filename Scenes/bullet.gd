class_name Bullet extends Node2D

@export var velocity = 300
@export var lifetime = 1.5 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = lifetime
	$Timer.timeout.connect(func(): self.queue_free())
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.RIGHT.rotated(rotation) * velocity * delta
