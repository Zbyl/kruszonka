extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var info = $Info
@onready var info_timer = $InfoTimer
var can_show_info: bool = true
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	info_timer.timeout.connect(try_show_info)
	info.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('Player'):
		info_timer.start()
		try_show_info()

func _on_area_2d_body_exited(body):
	info_timer.stop()

func try_show_info():
	if player.has_all_bunnies():
		GameData.game._on_player_won()
	elif can_show_info:
		can_show_info = false
		info.visible = true
		animation_player.play("float")
		animation_player.animation_finished.connect(hide_info)
			
func hide_info(anim_name):
	can_show_info = true
	info.visible = false
	animation_player.stop()
	
	

