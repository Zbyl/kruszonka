extends Node2D



var player
var active_tower: int = -1
var tower_buns: Array = [ [0, 1, 2], [], []]
var players_bun: int = -1
const BUN_HEIGHT = 30
var active: bool = false
var buns: Array
var markers: Array

const HEALING_EFFECT = preload("res://Scenes/healing_effect.tscn")


func sync_heights():
	var player_marker = player.get_node("%HanoiBunMarker")
	for bun in buns:
		bun.get_parent().remove_child(bun)
		player_marker.add_child(bun)
		bun.visible = true
		bun.global_position = player_marker.global_position
		
	for tower_idx in 3:
		for bun_idx in tower_buns[tower_idx].size():
			var tower_bun = tower_buns[tower_idx][bun_idx]
			var bun = buns[tower_bun]
			bun.get_parent().remove_child(bun)
			$Buns.add_child(bun)
			bun.visible = true
			bun.global_position = markers[tower_idx][bun_idx].global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	var ground_container = get_tree().get_first_node_in_group("HanoiGroundContainer")
	var ground = $Ground
	var ground_pos = ground.global_position
	ground.get_parent().remove_child(ground)
	ground_container.add_child(ground)
	ground.global_position = ground_pos
	
	player = get_tree().get_first_node_in_group("Player")
	buns = [$Buns/Bun0, $Buns/Bun1, $Buns/Bun2]
	markers = [
		[$Tower0/Marker0, $Tower0/Marker1, $Tower0/Marker2],
		[$Tower1/Marker0, $Tower1/Marker1, $Tower1/Marker2],
		[$Tower2/Marker0, $Tower2/Marker1, $Tower2/Marker2],
	]
	sync_heights()
	print_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not active:
		return
		
	var player_marker = player.get_node("%HanoiBunMarker").global_position
	var tower0_dist = ($Tower0.global_position - player_marker).length()
	var tower1_dist = ($Tower1.global_position - player_marker).length()
	var tower2_dist = ($Tower2.global_position - player_marker).length()
	active_tower = 0
	var tower_dist = tower0_dist
	if tower1_dist < tower_dist:
		active_tower = 1
		tower_dist = tower1_dist
	if tower2_dist < tower_dist:
		active_tower = 2
		tower_dist = tower2_dist
	
	if Input.is_action_just_pressed("action"):
		if players_bun == -1:
			try_pop_tower()
		else:
			try_push_tower()
		sync_heights()
			
func print_state():
	print("active_tower {active_tower} players_bun {players_bun}, tower_buns {tower_buns}".format({'active_tower': active_tower, 'players_bun': players_bun, 'tower_buns': tower_buns}))

func try_push_tower():	
	if active_tower == -1:
		return
		
	var tower_bun = tower_buns[active_tower].back() if tower_buns[active_tower].size() > 0 else -1
	if players_bun < tower_bun:
		print("cannot push players_bun=", players_bun, ' tower_bun=', tower_bun)
		print_state()
		return

	print("pushing")
	tower_buns[active_tower].push_back(players_bun)
	players_bun = -1
	print_state()
	
	if tower_buns[2].size() == 3:
		tower_completed()

func try_pop_tower():
	if active_tower == -1:
		return
		
	if tower_buns[active_tower].size() == 0:
		return

	print("popping")
	players_bun = tower_buns[active_tower].pop_back()
	print_state()


func _on_detector_body_entered(_body):
	active = true
	print("active ", active_tower)


func _on_detector_body_exited(_body):
	active = false
	active_tower = -1
	print("inactive ", active_tower)

func tower_completed():
	var effect0 = HEALING_EFFECT.instantiate()
	add_child(effect0)
	effect0.global_position = markers[1][2].global_position
	await get_tree().create_timer(0.5).timeout

	var effect1 = HEALING_EFFECT.instantiate()
	add_child(effect1)
	effect1.global_position = markers[0][1].global_position
	await get_tree().create_timer(0.7).timeout

	var effect2 = HEALING_EFFECT.instantiate()
	add_child(effect2)
	effect2.global_position = markers[2][0].global_position
	
	
