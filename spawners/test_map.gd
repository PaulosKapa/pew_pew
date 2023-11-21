extends Node3D
var floors = [Global.test_floor]
var walls = [Global.test_wall]
var props = [Global.test_prop]
var enemies = [Global.test_enemy]
func _ready():
	$floor_spawner.add_child(floors.pick_random().instantiate())
	$Enemy/spawner1.add_child(enemies.pick_random().instantiate())
	$Enemy/spawner2.add_child(enemies.pick_random().instantiate())
	$wall_spawner/spawner1.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner2.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner3.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner4.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner5.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner6.add_child(walls.pick_random().instantiate())
	$prop_spawner/spawner1.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner2.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner3.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner4.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner5.add_child(props.pick_random().instantiate())
	
