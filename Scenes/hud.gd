extends CanvasLayer

class_name Hud

enum WeaponType { GUN, BOOMERANG }

signal weapon_changed(weapon_type: WeaponType)
signal new_game_pressed()
signal exit_game_pressed()

@onready var weapons = $Screen/Weapons
@onready var gun_selection = $Screen/Weapons/GunSelection
@onready var boomerang_selection = $Screen/Weapons/BoomerangSelection
@onready var background = $Screen/Background
@onready var menu = $Screen/Menu
@onready var new_game_button = $Screen/Menu/MenuButtons/NewGameButton
@onready var initial_timer = $Screen/InitialTimer

var weapon_types: Array
var weapon_selections: Array
var current_weapon: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_types = [WeaponType.GUN, WeaponType.BOOMERANG]
	weapon_selections = [gun_selection, boomerang_selection]
	select_weapon(current_weapon)
	#initial_timer.timeout.connect(func(): select_weapon(current_weapon)) # Hack to properly select weapon.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("next_weapon"):
		next_weapon()
	if Input.is_action_just_pressed("prev_weapon"):
		prev_weapon()

	if Input.is_action_just_pressed("ui_menu"):
		toggle_menu()

func next_weapon():
	current_weapon = (current_weapon + 1) % weapon_selections.size()
	select_weapon(current_weapon)

func prev_weapon():
	current_weapon = (current_weapon + weapon_selections.size() - 1) % weapon_selections.size()
	select_weapon(current_weapon)

func select_weapon(index: int):
	print('Selectin weapon: ', index)
	for selection: CanvasItem in weapon_selections:
		selection.visible = false
		
	var selection = weapon_selections[index]
	selection.visible = true
	
	weapon_changed.emit(weapon_types[index])

func toggle_menu():
	show_menu(!menu.visible)

func show_menu(do_show: bool):
	menu.visible = do_show
	if do_show:
		new_game_button.grab_focus()

func show_weapons(do_show: bool):
	weapons.visible = do_show

func show_background(do_show: bool):
	background.visible = do_show

func _on_new_game_button_pressed():
	new_game_pressed.emit()


func _on_exit_game_button_pressed():
	exit_game_pressed.emit()
