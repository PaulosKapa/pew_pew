extends Node3D
#
var floors = [Global.test_floor]
var walls = [Global.test_wall, Global.table, Global.vending_machine, Global.tree1]
var props = [Global.test_prop, Global.barel_prop, Global.bench_prop, Global.metal_barel_prop, Global.fench_prop]
#var player = Global.player
#
func _ready():
	#
	##spawn floor, walls etc..
	$NavigationRegion3D/floor_spawner.add_child(floors.pick_random().instantiate())
	##if the enemies were children of the node, instead of just spawning at that location, their collision shapes interfere and break the game
	#
	##add the spawned enemies to the counter
	#
	$NavigationRegion3D/wall_spawner/spawner1.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner2.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner1.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner2.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner3.add_child(props.pick_random().instantiate())
	await get_tree().create_timer(2).timeout
	$NavigationRegion3D.bake_navigation_mesh()
	print($NavigationRegion3D.bake_finished)
	#
#

