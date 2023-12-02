extends map

func move():
	
	$Enemy/spawner1.global_translate(Vector3(0,0,randi_range(-1,1)))
	print($Enemy/spawner1.global_position.z)
	if($Enemy/spawner1.global_position.z>20):
		$Enemy/spawner1.global_translate(Vector3(0,0,-1))
	elif($Enemy/spawner1.global_position.z<-20):
		$Enemy/spawner1.global_translate(Vector3(0,0,1))
	$Enemy/spawner2.global_translate(Vector3(0,0,randi_range(-1,1)))
	if($Enemy/spawner2.global_position.z>20):
		$Enemy/spawner2.global_translate(Vector3(0,0,1))
	elif($Enemy/spawner2.global_position.z<-20):
		$Enemy/spawner2.global_translate(Vector3(0,0,-1))
