extends CharacterBody3D

@export var mouse_sensitivity = .3
@onready var weapon_holster = get_node("weapon_holster")
var weapons = [Global.test_weapon]
const JUMP_VELOCITY = 4.5
var camera_x_rotation = 0
var weapon_to_spawn = null
var health = 100
var sensitivity = 0.1
var can_rotate = true
var clicks = 0


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	equip_weapon()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	# Process input events
#	if Global.begin == true:
	process_input()

func process_input():
	#if(Global.get_mouse() == false):
	if(can_rotate == true):
		#CAMERA, maybe i forgot to add the arduino logic here
			get_parent().rotate_y(Controller.values[2].to_int() * 0.0005)
			$".".rotate_x(-Controller.values[1].to_int() * 0.0005)
			$".".rotation.x = clamp($".".rotation.x, -PI/2, PI/2)
					
		#rotate the raycast when rotating the gun
		#DONT USE IT, AT LEAST UNTIL FURTHER TESTING. 
		#if can_rotate == true and Global.data_list[3].to_int() == 1:
			#$RayCast3D.rotate_y(Global.data_list[2].to_int() * 0.0001)
			#$RayCast3D.rotate_x(-Global.data_list[1].to_int()* 0.0001)
			
		#hit the enemy
		
	#death()
	if $Camera3D/RayCast3D.is_colliding():
			var collider = $Camera3D/RayCast3D.get_collider()
			
			if(Input.is_action_just_pressed("click")):
				#teleport to the prop when pressing the button
				if(collider.is_in_group("ground") and Controller.values[4].to_int() == 0):
					move()
					can_rotate= false
				elif(collider.is_in_group("enemy")):
					if(weapon_to_spawn.shoot()>0):
						shoot(collider)
				elif(collider.is_in_group("target")):
				#get the parent of the target and call the despawn function
					if(weapon_to_spawn.shoot()>0):
						shoot(collider)
				elif(collider.is_in_group("player")):
					if(weapon_to_spawn.shoot()>0):
						shoot(collider)
			
	#enemy_shoot.rpc_id(enemy_shoot.get_multiplayer_authority())
#have to find how to get the nodes relatice to the player

func move():
	$".".set_position($Camera3D/RayCast3D.get_collision_point()-Vector3(0,-1,0))

func shoot(collider):
	collider = get_parent().get_node(collider)
	#print(get_node(collider))
	collider.set_health(collider.get_health()-weapon_to_spawn.get_dmg())
	if(collider.get_health() <=0):
		collider.get_tree().change_scene_to_file("res://scenes/main.tscn")

#func _input(event):
	##if(Controller.get_mouse()==true):
		#if event is InputEventMouseMotion:
			#get_parent().rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
			#var x_delta = event.relative.y * mouse_sensitivity 
#
			#if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
				#$".".rotate_x(deg_to_rad(-x_delta))
				#camera_x_rotation += x_delta
	##if event is InputEventMouseMotion:
		##$".".rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		##var x_delta = event.relative.y * mouse_sensitivity 
##
		##if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
			##$Camera3D.rotate_x(deg_to_rad(-x_delta))
			##camera_x_rotation += x_delta 

#getters and setters for health etc...
func set_health(hp):
	health = hp
	
func get_health():
	return health
func death():
	if(get_health()<=0):
		queue_free()

func equip_weapon():
	#placeholder code!!!!! the player will choose his gun at the main menu!! Delete later in production
	Global.set_weapon_id(1)
	
	#check which of the weapon in the game has the id of the weapon that the player has equiped and use that
	for weapon in weapons:
		
		if(weapon.instantiate().get_weapon_id_code() == Global.get_weapon_id()):
			weapon_to_spawn =  weapon.instantiate()
			
	weapon_holster.add_child(weapon_to_spawn)

