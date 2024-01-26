extends Node2D

const bullet = preload("res://Scenes/bullet.tscn")

var can_shoot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	$Timer.timeout.connect(func(): self.visible = false)
	$Cooldown.timeout.connect(func(): self.can_shoot = true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack") and can_shoot:
		visible = true
		$Timer.start()
		$Cooldown.start()
		
		shoot()
	

func shoot():
	
	var b = bullet.instantiate()
	b.global_position = $Muzzle.global_position
	b.global_rotation = $Muzzle.global_rotation
	can_shoot = false
	
	get_tree().root.add_child(b)
