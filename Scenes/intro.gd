extends Node2D

signal intro_ended()

@onready var animation_player = $CanvasLayer/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play('intro') # Replace with function body.
	animation_player.animation_finished.connect(send_ended)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action"):
		send_ended('xxx')

func send_ended(anim_name):
	intro_ended.emit()
