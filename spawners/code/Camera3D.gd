extends Camera3D

var sensitivity = 0.1
var can_rotate = true
var clicks = 0

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Process input events
	if Global.begin == true and Global.data_list[4].to_int() == 0:
		process_input()

func process_input():
	
	# Adjust the camera position based on input
#	var translation = Vector3(input_x, 0, input_z) * sensitivity
#	translation = translation.rotated(Vector3(0, 1, 0), -get_rotation().y)
#	translate(translation)
#func _unhandled_input(event):
#	if event is InputEventMouseMotion:
#		rotate_y(-event.relative.x * 0.005)
	#CAMERA
	get_parent().rotate_y(Global.data_list[2].to_int() * 0.0005)
	$".".rotate_x(-Global.data_list[1].to_int() * 0.0005)
	$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
	
	#RAYCAST
	can_rotate = true
	if $RayCast3D.is_colliding():
		var collider = $RayCast3D.get_collider()
		if (collider.is_in_group("prop") and Global.data_list[4].to_int() == 0):
			get_parent().get_parent().get_parent().set_position(collider.get_node("Node3D").global_position)
			can_rotate= false
	if can_rotate == true and Global.data_list[4].to_int() == 1:
		rotate_y(Global.data_list[2].to_int() * 0.0005)
		$RayCast3D.rotate_x(-Global.data_list[1].to_int()* 0.0005)
		
	if Global.data_list[5].to_int() == 0:
		if $Camera3D/RayCast3D.is_colliding():
	
			var collider = $Camera3D/RayCast3D.get_collider()
			print(collider)
			if collider.is_in_group("enemy"):
				collider.set_health(collider.get_health() - get_parent().get_dmg())

