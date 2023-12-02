extends RigidBody3D

var health = 100
var dmg = 10
func set_health(hp):
	health = hp
	
func get_health():
	return health

func get_dmg():
	return dmg
