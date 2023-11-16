extends RayCast3D

var can_rotate = true

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		$".".rotate_x(-event.relative.y * 0.005)
		$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	can_rotate = true
	if is_colliding():
		var collider = get_collider()
		if (collider.is_in_group("prop") and Input.is_action_just_pressed("click")):
			get_parent().get_parent().set_position(collider.global_position- Vector3(0,0,-2))
			can_rotate= false
	if can_rotate == true:
		if Input.is_action_just_pressed("click"):
			get_parent().get_parent().rotate_y(90)
	
