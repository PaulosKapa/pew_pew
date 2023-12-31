extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var health = 100
var dmg = 10
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		$Camera3D.rotate_x(-event.relative.y * 0.005)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)
		

func _physics_process(delta):
	if Input.is_action_just_pressed("pew"):
		if $Camera3D/RayCast3D.is_colliding():
	
			var collider = $Camera3D/RayCast3D.get_collider()
			print(collider)
			if collider.is_in_group("enemy"):
				collider.set_health(collider.get_health() - dmg)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	#print(get_health())
	if(get_health() <= 0):
		get_tree().reload_current_scene()

func set_health(hp):
	health = hp
	
func get_health():
	return health
