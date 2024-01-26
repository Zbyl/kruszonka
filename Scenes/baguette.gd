extends Area2D


@export var next_hit_possible: String = "hit1"
@onready var default_clayer = collision_layer

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	collision_layer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("punch"):
		if not visible:
			next_hit_possible = "hit1"
		if next_hit_possible != "":
			visible = true
			collision_layer = default_clayer
			
			$Anim.play(next_hit_possible)
			


func _on_anim_current_animation_changed(name):
	if name == "idle":
		visible = false
		collision_layer = 0
	else:
		visible = true
		collision_layer = default_clayer

