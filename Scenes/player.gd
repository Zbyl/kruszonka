extends CharacterBody2D

class_name Player

const SPEED = 500.0
const PUNCH_RADIUS = 90.0
const PUNCH_POWER = 100.0
const PUNCH_INNER_ANGLE = 30
const PUNCH_OUTER_ANGLE = 80

const CAMERA_AIM_OFFSET = 200
const CAMERA_MOVE_OFFSET = 200

const ENEMY_ATTACK_DAMAGE: float = 10.0 # Health damage caused by enemy attacks.
const MAX_SAVED_BUNNY_DISTANCE: float = 5.0 * 64

@onready var picture = $Picture
@onready var picture_container = $Picture/PictureContainer
@onready var cream_weapon: CreamWeapon = $Picture/CreamWeapon
@onready var boomerang_weapon: BoomerangWeapon = $Picture/CroissantGun
@onready var camera_target: Node2D = $CTMoveOffset/CameraTarget
@onready var camera_move_offset: Node2D = $CTMoveOffset
@onready var animation_player = $AnimationPlayer


var punch_tween: Tween
var paused: bool = false
var health: float = 100.0
var bunnies

const BLOOD = preload("res://Scenes/bite_blood.tscn")
@onready var blood_marker = $BloodMarker
var blood_container: Node2D

var _has_all_bunnies = false
var mouse_used = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func pause(do_pause: bool):
	paused = do_pause

func _ready():
	GameData.hud.weapon_changed.connect(_on_weapon_changed)
	_on_weapon_changed(GameData.hud.current_weapon)
	blood_container = get_tree().get_first_node_in_group("BloodContainer")
	bunnies = get_tree().get_nodes_in_group("Bunnies")

func _physics_process(_delta):
	if health <= 0:
		return
		
	if paused:
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_direction = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	
	var look_direction
	if mouse_used:
		look_direction = get_local_mouse_position().normalized()
	else:
		look_direction = Input.get_vector("rotate_left", "rotate_right", "rotate_up", "rotate_down")
	#look_direction = Vector2(-look_direction.y, look_direction.x)
	#print("move_direction", move_direction)
	if move_direction:
		velocity = move_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if look_direction:
		picture.look_at(global_position + look_direction)

	move_and_slide()
	
	if Input.is_action_just_pressed("punch"):
		punch_enemies()
	
		if punch_tween:
			punch_tween.kill()
		punch_tween = get_tree().create_tween()
		#tween.tween_property($Sprite, "modulate", Color.RED, 1)
		punch_tween.tween_property(picture_container, "scale", Vector2(1.3, 1), 0.07)
		punch_tween.parallel().tween_property(picture_container, "position", Vector2(5, 0), 0.07)
		punch_tween.tween_property(picture_container, "scale", Vector2(1, 1), 0.07)
		punch_tween.parallel().tween_property(picture_container, "position", Vector2(-5, 0), 0.07)
		#tween.tween_callback($Sprite.queue_free)		

	if Input.is_action_pressed("attack"):
		cream_weapon.try_shoot()
	if Input.is_action_just_pressed("attack"):
		boomerang_weapon.try_shoot()
	
	camera_move_offset.position = camera_move_offset.position.move_toward(move_direction * CAMERA_MOVE_OFFSET, _delta*CAMERA_MOVE_OFFSET*2)
	
	camera_target.position.x = move_toward(camera_target.position.x, look_direction.x * CAMERA_AIM_OFFSET, _delta*CAMERA_AIM_OFFSET*2)
	camera_target.position.y = move_toward(camera_target.position.y, look_direction.y * CAMERA_AIM_OFFSET, _delta*CAMERA_AIM_OFFSET*2)
	

func punch_enemies():
	#print("punch_enemies()")
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy: Enemy in enemies:
		#print('Rotation', rad_to_deg(picture.rotation))
		#print('Enemy angle', rad_to_deg(get_angle_to(enemy.global_position)))
		var angle_diff = rad_to_deg(get_angle_to(enemy.global_position) - picture.rotation)
		while angle_diff > 180.0:
			angle_diff -= 360.0
		while angle_diff < -180.0:
			angle_diff += 360.0
		#print('Enemy angle', angle_diff)
		angle_diff = abs(angle_diff)
		if angle_diff > PUNCH_OUTER_ANGLE:
			continue
		var punch_power = 1.0
		if angle_diff > PUNCH_INNER_ANGLE:
			punch_power = lerpf(1.0, 0.0, (angle_diff - PUNCH_INNER_ANGLE) / (PUNCH_OUTER_ANGLE - PUNCH_INNER_ANGLE))
		var vec_to_enemy: Vector2 = (enemy.global_position - global_position)
		#var dir_to_enemy: Vector2 = vec_to_enemy.normalized()
		if not vec_to_enemy:
			vec_to_enemy = Vector2.RIGHT
		if vec_to_enemy.length_squared() > PUNCH_RADIUS * PUNCH_RADIUS:
			continue
		#print("Punching")
		enemy.push_back_by_player(punch_power)
		
	return


func _on_weapon_changed(weapon_type: Hud.WeaponType):
	animation_player.play('idle')
	cream_weapon.activate(false)
	boomerang_weapon.activate(false)
	match weapon_type:
		Hud.WeaponType.GUN:
			print('Selected gun.')
			animation_player.play('gun')
			cream_weapon.activate(true)
		Hud.WeaponType.BOOMERANG:
			print('Selected boomerang.')
			boomerang_weapon.activate(true)


func hit_by_enemy(enemy: Enemy):
	var blood = BLOOD.instantiate()
	blood_container.add_child(blood)
	blood.global_position = blood_marker.global_position
	var dir_to_enemy = (enemy.global_position - global_position).normalized()
	blood.look_at(blood_marker.global_position - dir_to_enemy)
	
	health -= ENEMY_ATTACK_DAMAGE
	if health <= 0:
		health = 0
		animation_player.play('death')
		GameData.game._on_player_lost()

	GameData.hud.update_health_label(health)

func compute_saved_bunnies_count():
	var count = 0
	for bunny: Bunny in bunnies:
		var vec_to_bunny = bunny.global_position - global_position
		if vec_to_bunny.length() <= MAX_SAVED_BUNNY_DISTANCE:
			count += 1
		
	return count
	
func _on_hud_update_timer_timeout():
	var count = compute_saved_bunnies_count()
	var total = bunnies.size()
	_has_all_bunnies = count == total
	GameData.hud.update_buns_label(count, total)

func has_all_bunnies():
	return _has_all_bunnies
	
func _input(event):
	if event is InputEventMouse:
		mouse_used = true
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		mouse_used = false

func add_health():
	health = 100
	GameData.hud.update_health_label(health)
