extends Node3D
@export var weapon_id = 1
#1: semi, 2: burst, 3: auto, 4 semi+ burst, 5: semi + auto, 6: semi + burst + auto, 7: burst + auto, 9: pump/bolt, 9: laser
@export var shooting_mode = 1
@export var damage = 10
@export var firerate = 1
@export var condition = 100
@export var capacity = 12
@export var shooting_time = .2
var ammo
var magazines = {}
var magazineId

func get_weapon_id_code():
	return(weapon_id)
func get_weapon_shooting_mode():
	return(shooting_mode)
func get_dmg():
	return(damage)
func get_firerate():
	return(firerate)
func get_condition():
	return(condition)
func set_condition(cond):
	condition-=cond
#i should add a penetration and set dmg functions based on ammo type and not weapon.
#when loading the magazine
func load_ammo(magId):
	if (magazines.has(magId)):
		ammo = magazines[magId]
	else:
		ammo = capacity
#shooting function. Change the mmouse input logic with the esp buttons logic.
func shoot():
	if ammo>0:
		ammo -= 1
		await get_tree().create_timer(shooting_time).timeout
	return ammo

func _ready():
	pass
func _process(delta):
	pass
