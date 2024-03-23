extends CharacterBody3D
class_name enemy
@export var speed = 10
var target
var target_name
var previous_hit = null
@export var AP = 10
@export var fire_rate = 1
@export var health = 100
@onready var ray = $RayCast3D
var nearby_enemies = []

enum{IDLE,
	ALERT,
	HUNT,
	FOLLOW
}
var state = IDLE


func _physics_process(delta):
	#try to not collide enemies
	print(nearby_enemies)
	for enemy in nearby_enemies:
		#print(global_position>enemy.global_position+Vector3(1,0,1) or global_position>enemy.global_position+Vector3(-1,0,-1))
		if(global_position==enemy.global_position+Vector3(1,0,1)):
			global_position = global_position - Vector3(1,0,1)
	match state:
		
		HUNT:
			for enemy in nearby_enemies:
				follow(enemy)
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
					#if the ray still hits the same wall
					if(previous_hit == "wall"):
						target = null
						state = IDLE
					else:
						target = hit
						state = ALERT
			else:
				#when the ray stops hitting the wall, release
				previous_hit = null
		#if there is not a target, but there is a prop, go to the prop
		ALERT:
			for enemy in nearby_enemies:
				follow(enemy)
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
			var origin = ray.global_transform.origin
			var collision_point = ray.get_collision_point()
			
		
			if(sqrt((target.global_position.x-global_position.x)**2.0+(target.global_position.z-global_position.z)**2.0)<5):
				#print('done')
				state = IDLE
				target = null
				#use this to get the previouse hit of the enemy, so as not to get in a constant lock at the enemy
				previous_hit = "wall"
		
	#set the enemy spawner logic and delete the enemy
	if get_health() == 0:
		get_parent().get_parent().get_parent().set_enemy_player(get_parent().get_parent().get_parent().get_enemy_player() - 1)
		queue_free()

#when the player gets in the collision shape of the enemy
func _on_area_3d_body_entered(body):
	#else scout the map from prop to prop
	
	if body.is_in_group("prop") and state == IDLE:
		target = body
		state = ALERT
	#follow the leader
	elif body.is_in_group("enemy") and body!=$".":
		nearby_enemies.append(body)
		

#when they leave
func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		target = null
	elif body.is_in_group("enemy"):
		nearby_enemies.erase(body)

#move to the global position of the player
func move_to_target(delta):
	
	var direction = (target.get_parent().transform.origin - transform.origin).normalized()
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
#follow the leader enemy
func follow(enemy):
	enemy.target = target
	enemy.state = state
