extends Node3D
@export var weapon_name ="test_weapon"
@export var damage = 10
@export var firerate = 1
@export var condition = 100

func get_dmg():
	return(damage)
func get_firerate():
	return(firerate)
func get_condition():
	return(condition)
func set_condition(cond):
	condition-=cond
