extends Node3D
#new class
class_name map
#how many enemies are spawned. If it exeeds a number the game slows down a lot
var enemies_spawned = 0
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
	enemy.set_position($Enemy/spawner1.global_position)
	add_child(enemy)
	var enemy1 = enemies.pick_random().instantiate()
	enemy1.set_position($Enemy/spawner2.global_position)
	add_child(enemy1)
	#add the spawned enemies to the counter
	set_enemy_player(get_enemy_player()+2)
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
	var player_spawners = [$prop_spawner/spawner1.get_children(), $prop_spawner/spawner2.get_children(), $prop_spawner/spawner3.get_children(), $prop_spawner/spawner4.get_children(), $prop_spawner/spawner5.get_children()]	
	var child_spawner = player_spawners.pick_random()[0].get_children()
	var pl = (player.instantiate())
	#pl.set_position(child_spawner[2].global_position)
	#pl.set_rotation(child_spawner[2].global_rotation)
	#add_child(pl)
	#start the timer for the enemy spawner logic
	$Enemy/Timer.start()

func _process(delta):
	move()
	
	
func move():
	#move the enemy spawner nodes
	$Enemy/spawner1.global_translate(Vector3(randi_range(-1,1),0,0))
	#check if the spawner node gets out of bounds
	if($Enemy/spawner1.global_position.x>20):
		$Enemy/spawner1.global_translate(Vector3(-1,0,0))
	elif($Enemy/spawner1.global_position.x<-20):
		$Enemy/spawner1.global_translate(Vector3(1,0,0))
	$Enemy/spawner2.global_translate(Vector3(randi_range(-1,1),0,0))
	if($Enemy/spawner2.global_position.x>20):
		$Enemy/spawner2.global_translate(Vector3(-1,0,0))
	elif($Enemy/spawner2.global_position.x<-20):
		$Enemy/spawner2.global_translate(Vector3(1,0,0))
	


func _on_timer_timeout():
	#if there are less than 10 enemies spawn them
	if get_enemy_player()<10:
		var enemy = enemies.pick_random().instantiate()
		enemy.set_position($Enemy/spawner1.global_position)
		add_child(enemy)
		var enemy1 = enemies.pick_random().instantiate()
		enemy1.set_position($Enemy/spawner1.global_position)
		add_child(enemy1)
		set_enemy_player(get_enemy_player()+2)
	$Enemy/Timer.stop()
	$Enemy/Timer.start()
	#getters and setters for the spwner logic
func get_enemy_player():
	return enemies_spawned
func set_enemy_player(enemy):
	enemies_spawned = enemy
