extends Node3D
#the spawners
var spawner_list = ["target_spawners/target","target_spawners/target2","target_spawners/target3","target_spawners/target4","target_spawners/target5"]
var spawned_target = []
var target = Global.test_target
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()
	$respawn.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func spawn():
	#a random number of spawners, based on how many we have
	var number_of_spawners = randi()%len(spawner_list) + 1
	
	#for the number of spawners
	for spawner_pos in number_of_spawners:
		#what spawner to show
		var spawner_to_show = randi()%len(spawner_list)
		#check if the spawner isnt already shown
		var can_spawn = false
		
		while(can_spawn == false):
			if(get_node(spawner_list[spawner_to_show]).visible == true):
				
				spawner_to_show = randi()%len(spawner_list)
				
			else:
				#add the spawner to a list of spawners that are visible
				spawned_target.append(spawner_list[spawner_to_show])
				
				get_node(spawner_list[spawner_to_show]).show()
			
				
				can_spawn = true
		

	$spawn.start()
#callable from the player script, when you shoot down the target
func despawn(col):
	#hide the target
	col.hide()
	#delete it from the array so it doesnt have to hide it again
	spawned_target.erase(str(get_path_to(col)))
	
func _on_spawn_timeout():
	#delete and hide the shown spawners
	print(spawned_target)
	for spawned_expired_target in spawned_target:
		
		get_node(spawned_expired_target).hide()
	spawned_target.clear()
	
	$spawn.stop()


func _on_respawn_timeout():
	$respawn.stop()
	spawn()
	$respawn.start()
