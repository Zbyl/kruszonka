extends Node2D



var player
var active_tower: int = -1
var tower_buns: Array = [ [0, 1, 2], [], []]
var players_bun: int = -1
const BUN_HEIGHT = 30
var active: bool = false

func sync_heights():
	var buns = [$Buns/Bun0, $Buns/Bun1, $Buns/Bun2]
	var markers = [
		[$Tower0/Marker0, $Tower0/Marker1, $Tower0/Marker2],
		[$Tower1/Marker0, $Tower1/Marker1, $Tower1/Marker2],
		[$Tower2/Marker0, $Tower2/Marker1, $Tower2/Marker2],
	]
	for bun in buns:
		bun.visible = false
		
	for tower_idx in 3:
		for bun_idx in tower_buns[tower_idx].size():
			var tower_bun = tower_buns[tower_idx][bun_idx]
			buns[tower_bun].global_position = markers[tower_idx][bun_idx].global_position
			buns[tower_bun].visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	sync_heights()
	print_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
