extends CharacterBody3D

@onready var nav = $NavigationAgent3D
var speed = 10
var accel = 10
var target
func _physics_process(delta):

	var hit = $RayCast3D.get_collider()
	if(hit!=null):
	
		if(hit.is_in_group("player")):
			target = hit
			move(target, delta)
func move(target, delta):
	var direction = Vector3()
	nav.target_position = target.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction*speed, accel*delta)
	look_at(target.global_transform.origin, Vector3.UP)
	move_and_slide()
	
