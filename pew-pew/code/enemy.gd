extends CharacterBody3D
var speed = 1
var target
@export var AP = 10
@export var fire_rate = 1
@export var health = 100

func _process(delta):
	if(target):
		look_at(target.global_transform.origin, Vector3.UP)
		move_to_target(delta)
		shoot()
	#if there is not a target, rotate the enemy until they raycast finds the player
	if(target==null):
		$".".rotate_y(.01)
		var hit = $RayCast3D.get_collider()
		
		if(hit!=null):
			if(hit.is_in_group("player")):
				target=hit
	#set the enemy spawner logic and delete the enemy
	if get_health() == 0:
		get_parent().get_parent().get_parent().set_enemy_player(get_parent().get_parent().get_parent().get_enemy_player() - 1)
		queue_free()

#when the player gets in the collision shape of the enemy
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		target = body
		

#when they leave
func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		target = null

#move to the global position of the player
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


func shoot():
	#hit the player with a ray
	var hit = $RayCast3D.get_collider()
	
	if(hit!=null):
		
		if(hit.is_in_group("player")):
			var succesfull_hit=[true, false]
			#get the distance
			var origin = $RayCast3D.global_transform.origin
			var collision_point = $RayCast3D.get_collision_point()
			var distance = origin.distance_to(collision_point)
			#check if there is a succesfull hit
			if(succesfull_hit.pick_random() == true):
				#check if the damage is bigger than 0
				if(int(AP-(distance/10))>0):
					#hit and set a timer
					hit.set_health(hit.get_health()-int(AP-(distance/10)))
				await get_tree().create_timer(fire_rate).timeout

#setters and getters for the health
func get_health():
	return(health)
func set_health(hp):
	health = hp
