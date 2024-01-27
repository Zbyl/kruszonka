extends Node2D

class_name Sprinkler

var paused: bool = false
var health: float = 100.0
var last_boomerang_hit = -1000000
const PUNCH_DAMAGE = 40
const BULLET_DAMAGE = 34
const BOOMERANG_DAMAGE = 60
const BOOMERANG_IMMUNE_TIME = 300
@export var ROTATION_SPEED: float = 180 # Degrees per second.
const DROP = preload("res://Scenes/drop.tscn")
const EXPLOSION = preload("res://Scenes/explosion.tscn")
@onready var drop_container = $DropContainer
@onready var hit_sound = $HitSound
@onready var death_sound = $DeathSound
@onready var splash_sound = $SplashSound
@onready var splash_timer = $SplashTimer
@onready var picture = $Picture
@onready var drop_marker = $Picture/DropMarker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	picture.rotation += deg_to_rad(ROTATION_SPEED * delta)


func pause(do_pause: bool):
	paused = do_pause


func hit_by_boomerang():
	if Time.get_ticks_msec() >= last_boomerang_hit + BOOMERANG_IMMUNE_TIME: 
		_on_hit(BOOMERANG_DAMAGE)
		last_boomerang_hit = Time.get_ticks_msec()

func hit_by_bullet():
	_on_hit(BULLET_DAMAGE)

func push_back_by_player(punch_power: float):
	_on_hit(punch_power * PUNCH_DAMAGE)

func _on_hit(damage: float):
	if health <= 0:
		return
		
	health -= damage
	if health <= 0:
		death_sound.play()
		var explosion = EXPLOSION.instantiate()
		add_child(explosion)
		picture.visible = false
		await explosion.particles_finished
		queue_free()
	else:
		hit_sound.play()

	
func _on_shoot_timer_timeout():
	var drop = DROP.instantiate()
	drop_container.add_child(drop)
	drop.global_position = drop_marker.global_position
	drop.rotation = picture.rotation


func _on_splash_timer_timeout():
	splash_sound.play()
	
