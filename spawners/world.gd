extends Node3D
var maps = [Global.test_map, Global.map1]

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".add_child(maps.pick_random().instantiate())


