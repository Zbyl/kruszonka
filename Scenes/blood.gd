extends Node2D

@onready var cpu_particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	cpu_particles_2d.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cpu_particles_2d_finished():
	self.queue_free()
