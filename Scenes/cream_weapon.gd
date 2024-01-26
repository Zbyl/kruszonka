extends Node2D

class_name CreamWeapon

const bullet = preload("res://Scenes/bullet.tscn")

var activated = false	# True if weapon is currently active.
var can_shoot = true	# True if cooldown finished.

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	$Cooldown.timeout.connect(func(): self.can_shoot = true)


func _physics_process(delta):
	if activated and can_shoot and Input.is_action_pressed("attack"):
		can_shoot = false
		$Cooldown.start()
		shoot()
	

func activate(should_activate: bool):
	if should_activate:
		self.visible = true
		activated = true
	else:
		self.visible = false
		activated = false

func shoot():
	var b = bullet.instantiate()
	b.global_position = $Muzzle.global_position
	b.global_rotation = $Muzzle.global_rotation
	
	get_tree().root.add_child(b)
