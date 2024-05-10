extends CharacterBody3D
class_name enemynav
@onready var nav = $NavigationAgent3D
@export var speed = 10
@export var accel = 10
var target
var target_name
var previous_hit = null
@export var AP = 10
@export var fire_rate = 1
@export var health = 100
@onready var ray = $RayCast3D
@onready var ground_ray = $RayCast3D2
var moving = true
var player_is_nearby = false
var height_position
enum{IDLE,
	ALERT,
	HUNT,
	#FOLLOW,
	STORY
}
var state = IDLE

func _physics_process(delta):
	
	if(height_position==null):
		var hit = ground_ray.get_collider()
		
		if(hit!=null):
			if(hit.is_in_group("ground")):
			
			
				#get the distance from the ground
				var origin = ground_ray.global_transform.origin
				var collision_point = ground_ray.get_collision_point()
				var distance = origin.distance_to(collision_point)
				height_position = distance
	#keep the same distance form the ground at all time
	else:
		
		global_position.y = height_position
	match state:
		HUNT:
			if(sqrt((target.global_position.x-global_position.x)**2.0+(target.global_position.z-global_position.z)**2.0)<5):
				moving = false
			else:
				moving = true
			move(target, delta, moving)
			shoot()
			if(player_is_nearby == false and ray.get_collider() == null):
				state = IDLE
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
		ALERT:
			move(target, delta, true)
			var origin = ray.global_transform.origin
			var collision_point = ray.get_collision_point()
			if(sqrt((target.global_position.x-global_position.x)**2.0+(target.global_position.z-global_position.z)**2.0)<5):
				
				#print('done')
				state = IDLE
				target = null
				#use this to get the previouse hit of the enemy, so as not to get in a constant lock at the enemy
				previous_hit = "wall"
	death()
	
			
func move(target, delta, moving):
	if(target!=null and moving == true):
		var direction = Vector3()
		nav.target_position = target.global_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction*speed, accel*delta)
		look_at(target.global_transform.origin, Vector3.UP)
		move_and_slide()

	
func death():
	if get_health() == 0:
		queue_free()

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
					#print(hit.get_health())
				await get_tree().create_timer(fire_rate).timeout

#setters and getters for the health
func get_health():
	return(health)
func set_health(hp):
	health = hp

func _on_area_3d_body_entered(body):
	if(body.is_in_group("player")):
		player_is_nearby = true

func _on_area_3d_body_exited(body):
	if(body.is_in_group("player")):
		player_is_nearby = false
