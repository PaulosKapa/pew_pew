extends Camera3D

var sensitivity = 0.1
var can_rotate = true
var clicks = 0

@export var mouse_sensitivity = .3
var camera_x_rotation = 0

func _ready():
	#lock the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Process input events
	if Global.begin == true:
		process_input()

func process_input():
	if(Global.get_mouse() == false):
		if(can_rotate == true):
		#CAMERA, maybe i forgot to add the arduino logic here
			get_parent().rotate_y(Global.data_list[2].to_int() * 0.0005)
			$".".rotate_x(-Global.data_list[1].to_int() * 0.0005)
			$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
		
		#RAYCAST
		
		
		if $RayCast3D.is_colliding():
			var collider = $RayCast3D.get_collider()
			#teleport to the prop when pressing the button
			if (collider.is_in_group("prop") and Global.data_list[3].to_int() == 0):
				get_parent().get_parent().get_parent().set_position(collider.get_node("Node3D").global_position)
				can_rotate= false
		#rotate the raycast when rotating the gun
		#DONT USE IT, AT LEAST UNTIL FURTHER TESTING. 
		#if can_rotate == true and Global.data_list[3].to_int() == 1:
			#$RayCast3D.rotate_y(Global.data_list[2].to_int() * 0.0001)
			#$RayCast3D.rotate_x(-Global.data_list[1].to_int()* 0.0001)
			
		#hit the enemy
		if Global.data_list[4].to_int() == 0:
			if $RayCast3D.is_colliding():
		
				var collider = $RayCast3D.get_collider()
				#print(collider)
				if collider.is_in_group("enemy"):
					collider.set_health(collider.get_health() - get_parent().get_dmg())

		
func _input(event):
	if(Global.get_mouse()==true):
		if event is InputEventMouseMotion:
			get_parent().rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			var x_delta = event.relative.y * mouse_sensitivity 

			if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
				$".".rotate_x(deg_to_rad(-x_delta))
				camera_x_rotation += x_delta 
		
