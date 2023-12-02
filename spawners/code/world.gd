extends Node3D
#declare a var for the maps and the environments
var maps = [Global.test_map, Global.map1, Global.map2, Global.map3]
var env = [Global.env1, Global.env2]

# Called when the node enters the scene tree for the first time.
func _ready():
	#add the child (map)
	add_child(maps.pick_random().instantiate())
	#add an environment
	$WorldEnvironment.set_environment(env.pick_random())

