extends CharacterBody3D
class_name enemy
@export var speed = 10
var target
var target_name
@export var AP = 10
@export var fire_rate = 1
@export var health = 100
@onready var ray = $RayCast3D
enum{IDLE,
	ALERT,
	HUNT
}
var state = IDLE


func _process(delta):
	
	match state:
		
		HUNT:
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
			shoot()
	
		
	#if there is not a target, rotate the enemy until they raycast finds the player
		IDLE:
			$".".rotate_y(.01)
			var hit = ray.get_collider()
			if(hit!=null):
				if(hit.is_in_group("player")):
					target=hit
					state = HUNT
				elif(hit.is_in_group("wall")):
					target = hit
					state = ALERT
		#if there is not a target, but there is a prop, go to the prop
		ALERT:
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
		#	print(sqrt((target.global_position.x-global_position.x)**2.0+(target.global_position.z-global_position.z)**2.0))
			if(sqrt((target.global_position.x-global_position.x)**2.0+(target.global_position.z-global_position.z)**2.0)<2):
				print('done')
				state = IDLE
				target = null

	#set the enemy spawner logic and delete the enemy
	if get_health() == 0:
		get_parent().get_parent().get_parent().set_enemy_player(get_parent().get_parent().get_parent().get_enemy_player() - 1)
		queue_free()

#when the player gets in the collision shape of the enemy
func _on_area_3d_body_entered(body):

	#if they find the player
	if body.is_in_group("player"):
		target = body
		state = HUNT
		
	#else scout the map from prop to prop
	elif body.is_in_group("prop") and state == IDLE:
		target = body
		state = ALERT
		
		
	#elif body.is_in_group("wall") and state == IDLE:
	#	target = body
	#	state = ALERT

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
	var hit = ray.get_collider()
	
	if(hit!=null):
		
		if(hit.is_in_group("player")):
			var succesfull_hit=[true, false]
			#get the distance
			var origin = ray.global_transform.origin
			var collision_point = ray.get_collision_point()
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

