extends CanvasLayer

class_name Hud

enum WeaponType { GUN, BOOMERANG }

signal weapon_changed(weapon_type: WeaponType)

@onready var gun_selection = $Control/GunSelection
@onready var boomerang_selection = $Control/BoomerangSelection

var weapon_types: Array
var weapon_selections: Array
var current_weapon: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_types = [WeaponType.GUN, WeaponType.BOOMERANG]
	weapon_selections = [gun_selection, boomerang_selection]
	select_weapon(current_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("next_weapon"):
		next_weapon()
	if Input.is_action_just_pressed("prev_weapon"):
		prev_weapon()

func next_weapon():
	current_weapon = (current_weapon + 1) % weapon_selections.size()
	select_weapon(current_weapon)

func prev_weapon():
	current_weapon = (current_weapon + weapon_selections.size() - 1) % weapon_selections.size()
	select_weapon(current_weapon)

func select_weapon(index: int):
	for selection: CanvasItem in weapon_selections:
		selection.visible = false
		
	var selection = weapon_selections[index]
	selection.visible = true
	
	weapon_changed.emit(weapon_types[index])
