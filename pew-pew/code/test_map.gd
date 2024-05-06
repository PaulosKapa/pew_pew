extends Node3D
#new class
class_name map

#declare variables for needed assets
var floors = [Global.test_floor]
var walls = [Global.test_wall, Global.table, Global.vending_machine, Global.tree1]
var props = [Global.test_prop, Global.barel_prop, Global.bench_prop, Global.metal_barel_prop, Global.fench_prop]
var enemies = [Global.test_enemy, Global.enemy_drone001, Global.enemy_drone002, Global.enemy_drone003, Global.enemy_drone004]
var player = Global.player

func _ready():
	
	#spawn floor, walls etc..
	$floor_spawner.add_child(floors.pick_random().instantiate())
	#if the enemies were children of the node, instead of just spawning at that location, their collision shapes interfere and break the game
	var enemy = enemies.pick_random().instantiate()
	
	#$Enemy/spawner1.add_child(enemy)
	#enemy.set_as_top_level(true)
	var enemy1 = enemies.pick_random().instantiate()
	
	$Enemy/spawner2.add_child(enemy1)
	enemy1.set_as_top_level(true)
	#add the spawned enemies to the counter
	
	$wall_spawner/spawner1.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner2.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner3.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner4.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner5.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner6.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner7.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner8.add_child(walls.pick_random().instantiate())
	$prop_spawner/spawner1.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner2.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner3.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner4.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner5.add_child(props.pick_random().instantiate())
	#add the player as a child of the parent node, not a simple node. Then get the node's rotation and position
	#var player_spawners = [$prop_spawner/spawner1.get_children(), $prop_spawner/spawner2.get_children(), $prop_spawner/spawner3.get_children(), $prop_spawner/spawner4.get_children(), $prop_spawner/spawner5.get_children()]	
	#var child_spawner = player_spawners.pick_random()[0].get_children()
	#var pl = (player.instantiate())
	#pl.set_position(child_spawner[2].global_position)
	#pl.set_rotation(child_spawner[2].global_rotation)
	#add_child(pl)
	
	#start the timer for the enemy spawner logic
	$Enemy/Timer.start()


func _physics_process(delta):
		if(Input.is_action_just_pressed("ui_accept")):
			Engine.time_scale = 2
		elif(Input.is_action_just_released("ui_accept")):
			Engine.time_scale = 1

func _on_timer_timeout():
	#if there are less than 10 enemies spawn them
	if($Enemy/spawner1.get_child_count()+$Enemy/spawner2.get_child_count()<10):
		var enemy = enemies.pick_random().instantiate()
		#
	#
		$Enemy/spawner1.add_child(enemy)
		enemy.set_as_top_level(true)
		#var enemy1 = enemies.pick_random().instantiate()
	#
		#$Enemy/spawner2.add_child(enemy1)	
		#enemy1.set_as_top_level(true)
	$Enemy/Timer.stop()
	$Enemy/Timer.start()


