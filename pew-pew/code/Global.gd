extends Node
#preload all the resourses
#floors
var test_floor =  preload("res://scenes/floor.tscn")
#walls
var test_wall =  preload("res://scenes/wall.tscn")
var table = preload("res://scenes/wall.tscn")
var vending_machine = preload("res://scenes/vending machine.tscn")
var tree1 = preload("res://scenes/tree.tscn")
#props
var test_prop = preload("res://scenes/prop.tscn")
var barel_prop = preload("res://scenes/barel.tscn")
var bench_prop = preload("res://scenes/bench.tscn")
var metal_barel_prop = preload("res://scenes/metal_barel.tscn")
var fench_prop = preload("res://scenes/fench.tscn")
#target
var test_target = preload("res://scenes/target.tscn")
#enemies
var test_enemy = preload("res://scenes/enemy.tscn")
var enemy_drone001 = preload("res://scenes/drone_ground.tscn")
var enemy_drone002 = preload("res://scenes/drone_patrol.tscn")
var enemy_drone003 = preload("res://scenes/drone_sky.tscn")
var enemy_drone004 = preload("res://scenes/drone_wheels.tscn")
#maps
var test_map = preload("res://scenes/test_map.tscn")
var player = preload("res://scenes/player.tscn")
var multi_player = preload("res://scenes/multiplayer_test.tscn")
var env1 = preload("res://environments/environment1.tres")
#weapons
var test_weapon = preload("res://scenes/weapon.tscn")
var env2 = preload("res://environments/environment2.tres")
var weapon_id = null
var multiplay = null
#get and se the weapon that the player will use. The id will be set via the esp. Probably placeholder code for nows
func get_weapon_id():
	return(weapon_id)
func set_weapon_id(weapon):
	weapon_id = weapon
func set_multiplay(multi):
	multiplay = multi
func get_multiplay():
	return(multiplay)	

