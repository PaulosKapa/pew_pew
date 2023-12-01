extends CharacterBody3D
var speed = 1
var target
@export var AP = 10
@export var fire_rate = 1

func _process(delta):
	if(target):
		look_at(target.global_transform.origin, Vector3.UP)
		#move_to_target(delta)
		shoot()
	if(target==null):
		$".".rotate_y(.01)
		var hit = $RayCast3D.get_collider()
		if(hit!=null):
			if(hit.is_in_group("player")):
				target=hit
		
			
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		target = body
		


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()


func shoot():
	
	var hit = $RayCast3D.get_collider()
	if(hit!=null):
		
		if(hit.is_in_group("player")):
			var succesfull_hit=[true, false]
			var origin = $RayCast3D.global_transform.origin
			var collision_point = $RayCast3D.get_collision_point()
			var distance = origin.distance_to(collision_point)
			

			
			if(succesfull_hit.pick_random() == true):
				if(int(AP-(distance/10))>0):
					hit.set_health(hit.get_health()-int(AP-(distance/10)))
				await get_tree().create_timer(fire_rate).timeout

