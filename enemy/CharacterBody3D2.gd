extends CharacterBody3D
var speed = 1
var target

func _process(delta):
	if(target):
		look_at(target.global_transform.origin, Vector3.UP)
		move_to_target(delta)
		
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		target = body
		print(target," entered")


func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		print(body," exited")
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity = direction * speed
	move_and_slide()
