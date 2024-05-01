extends Node3D
#the spawners
var spawner_list = ["target_spawners/spawner","target_spawners/spawner2","target_spawners/spawner3","target_spawners/spawner4","target_spawners/spawner5"]
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
				spawned_target.append(spawner_to_show)
				get_node(spawner_list[spawner_to_show]).show()
				
				
				can_spawn = true
	$spawn.start()

func _on_spawn_timeout():
	#delete and hide the shown spawners
	
	for spawned_expired_target in spawned_target:
		
		get_node(spawner_list[spawned_expired_target]).hide()
	spawned_target.clear()
	
	$spawn.stop()


func _on_respawn_timeout():
	$respawn.stop()
	spawn()
	$respawn.start()
