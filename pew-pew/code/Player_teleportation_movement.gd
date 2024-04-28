extends RigidBody3D


@export var mouse_sensitivity = .3

const JUMP_VELOCITY = 4.5
var camera_x_rotation = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Camera3D/RayCast3D.is_colliding():
			var collider = $Camera3D/RayCast3D.get_collider()
			if(collider.is_in_group("ground") and Input.is_action_just_pressed("click")):
				$".".set_position($Camera3D/RayCast3D.get_collision_point()-Vector3(0,-1,0))
				
func _input(event):
	if event is InputEventMouseMotion:
		$".".rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity 

		if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
			$Camera3D.rotate_x(deg_to_rad(-x_delta))
			camera_x_rotation += x_delta 
