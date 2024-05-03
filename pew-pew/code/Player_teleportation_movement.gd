extends RigidBody3D

@export var mouse_sensitivity = .3
@onready var weapon_holster = get_node("weapon_holster")
var weapons = [Global.test_weapon]
const JUMP_VELOCITY = 4.5
var camera_x_rotation = 0
var weapon_to_spawn = null
var movement = true
# Called when the node enters the scene tree for the first time.
func _ready():
	#placeholder code!!!!! the player will choose his gun at the main menu!! Delete later in production
	Global.set_weapon_id(1)
	
	#check which of the weapon in the game has the id of the weapon that the player has equiped and use that
	for weapon in weapons:
		
		if(weapon.instantiate().get_weapon_id_code() == Global.get_weapon_id()):
			weapon_to_spawn =  weapon.instantiate()
			
	weapon_holster.add_child(weapon_to_spawn)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Camera3D/RayCast3D.is_colliding() and get_movement() == true:
			var collider = $Camera3D/RayCast3D.get_collider()
			if(collider.is_in_group("ground") and Input.is_action_just_pressed("click")):
				$".".set_position($Camera3D/RayCast3D.get_collision_point()-Vector3(0,-1,0))
			elif(collider.is_in_group("enemy") and Input.is_action_just_pressed("click")):
				collider.set_health(collider.get_health()-weapon_to_spawn.get_dmg())
			elif(collider.is_in_group("target") and Input.is_action_just_pressed("click")):
				#get the parent of the target and call the despawn function
				collider.get_parent().get_parent().get_parent().despawn(collider)
				
func _input(event):
	if event is InputEventMouseMotion and get_movement() == true:
		$".".rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity 

		if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
			$Camera3D.rotate_x(deg_to_rad(-x_delta))
			camera_x_rotation += x_delta 
#for the pause menu
func get_movement():
	return movement
func set_movement(move):
	movement = move
