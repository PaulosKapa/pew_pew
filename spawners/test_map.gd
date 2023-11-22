extends Node3D

class_name map

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
	$wall_spawner/spawner7.add_child(walls.pick_random().instantiate())
	$wall_spawner/spawner8.add_child(walls.pick_random().instantiate())
	$prop_spawner/spawner1.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner2.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner3.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner4.add_child(props.pick_random().instantiate())
	$prop_spawner/spawner5.add_child(props.pick_random().instantiate())
	$Enemy/Timer.start()

func _process(delta):
	move()
	
func move():
	
	$Enemy/spawner1.global_translate(Vector3(randi_range(-1,1),0,0))
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
	$Enemy/spawner1.add_child(enemies.pick_random().instantiate())
	$Enemy/spawner2.add_child(enemies.pick_random().instantiate())
	$Enemy/Timer.stop()
	$Enemy/Timer.start()
