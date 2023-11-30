extends Camera3D

var sensitivity = 0.1

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
	get_parent().rotate_y(Global.data_list[2].to_int() * 0.0005)
	$".".rotate_x(-Global.data_list[1].to_int() * 0.0005)
	$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
