extends RayCast3D

var can_rotate = true
var clicks = 0

		
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.begin == true:
		can_rotate = true
		if is_colliding():
			var collider = get_collider()
			if (collider.is_in_group("prop") and Global.data_list[4].to_int() == 0):
				get_parent().get_parent().get_parent().set_position(collider.get_node("Node3D").global_position)
				can_rotate= false
		if can_rotate == true and Global.data_list[4].to_int() == 1:
			rotate_y(Global.data_list[2].to_int() * 0.0005)
			$".".rotate_x(-Global.data_list[1].to_int()* 0.0005)
#		$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
#		get_parent().rotate_y(Global.data_list[2].to_int() * 0.0005)
#	$".".rotate_x * 0.0005)
#	$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)

		
