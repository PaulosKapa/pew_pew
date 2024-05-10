extends Node3D
#new class
class_name map

#declare variables for needed assets
var floors = [Global.test_floor]
var walls = [Global.test_wall, Global.table, Global.vending_machine, Global.tree1]
var props = [Global.test_prop, Global.barel_prop, Global.bench_prop, Global.metal_barel_prop, Global.fench_prop]
var enemies = [Global.test_enemy, Global.enemy_drone001, Global.enemy_drone002, Global.enemy_drone003, Global.enemy_drone004]
var player = Global.multi_player

func _ready():
	
	#spawn floor, walls etc..
	$NavigationRegion3D/floor_spawner.add_child(floors.pick_random().instantiate())
	#if the enemies were children of the node, instead of just spawning at that location, their collision shapes interfere and break the game
	
	#add the spawned enemies to the counter
	
	$NavigationRegion3D/wall_spawner/spawner1.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner2.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner3.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner4.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner5.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner6.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner7.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/wall_spawner/spawner8.add_child(walls.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner1.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner2.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner3.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner4.add_child(props.pick_random().instantiate())
	$NavigationRegion3D/prop_spawner/spawner5.add_child(props.pick_random().instantiate())
	#did it like that because multiplayer couldnt get the node
	await get_tree().create_timer(2).timeout
	$NavigationRegion3D.bake_navigation_mesh()
	print($NavigationRegion3D.bake_finished)
	var enemy = enemies.pick_random().instantiate()
	
	$Enemy.add_child(enemy)
	
	enemy.set_as_top_level(true)
	enemy.global_position = $Enemy/spawner1.global_position
	var enemy1 = enemies.pick_random().instantiate()
	
	$Enemy.add_child(enemy1)
	enemy1.set_as_top_level(true)
	enemy1.global_position = $Enemy/spawner2.global_position
	#add the player as a child of the parent node, not a simple node. Then get the node's rotation and position
	#var player_spawners = [$prop_spawner/spawner1.get_children(), $prop_spawner/spawner2.get_children(), $prop_spawner/spawner3.get_children(), $prop_spawner/spawner4.get_children(), $prop_spawner/spawner5.get_children()]	
	#var child_spawner = player_spawners.pick_random()[0].get_children()
	#var pl = (player.instantiate())
	#pl.set_position(child_spawner[2].global_position)
	#pl.set_rotation(child_spawner[2].global_rotation)
	add_child(player.instantiate())
	
	#start the timer for the enemy spawner logic
	$Enemy/Timer.start()


func _on_timer_timeout():
	#if there are less than 10 enemies spawn them
	if($Enemy.get_child_count()<10):
		var enemy = enemies.pick_random().instantiate()
		
		$Enemy.add_child(enemy)
		enemy.set_as_top_level(true)
		enemy.global_position = $Enemy/spawner1.global_position
		var enemy1 = enemies.pick_random().instantiate()
		
		$Enemy.add_child(enemy1)
		enemy1.set_as_top_level(true)
		enemy1.global_position = $Enemy/spawner2.global_position
	$Enemy/Timer.stop()
	$Enemy/Timer.start()


