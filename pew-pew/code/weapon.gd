extends Node3D
@export var weapon_id = 1
@export var damage = 10
@export var firerate = 1
@export var condition = 100

func get_weapon_id_code():
	return(weapon_id)
func get_dmg():
	return(damage)
func get_firerate():
	return(firerate)
func get_condition():
	return(condition)
func set_condition(cond):
	condition-=cond
#i should add a penetration and set dmg functions based on ammo type and not weapon.
