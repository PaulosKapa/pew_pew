extends RigidBody3D

var health = 100
var dmg = 10
#the death logic
func _process(delta):
	if(get_health() <=0):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
#getters and setters for health etc...
func set_health(hp):
	health = hp
	
func get_health():
	return health

func get_dmg():
	return dmg
