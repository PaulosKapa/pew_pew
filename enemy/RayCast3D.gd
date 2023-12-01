extends RayCast3D



signal hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("player"):
			emit_signal("hit") 

