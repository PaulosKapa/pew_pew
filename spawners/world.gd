extends Node3D
var maps = [Global.test_map]

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".add_child(maps.pick_random().instantiate())


