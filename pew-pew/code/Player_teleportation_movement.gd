extends CharacterBody3D

@export var mouse_sensitivity = .3
@onready var weapon_holster = get_node("weapon_holster")
var weapons = [Global.test_weapon]
const JUMP_VELOCITY = 4.5
var camera_x_rotation = 0
var weapon_to_spawn = null
var health = 10

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_multiplayer_authority(): return
	equip_weapon.rpc()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera3D.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	
	if not is_multiplayer_authority(): return
	
	if $Camera3D/RayCast3D.is_colliding():
			var collider = $Camera3D/RayCast3D.get_collider()
			
			if(Input.is_action_just_pressed("click")):
				if(collider.is_in_group("ground")):
					move.rpc()
				elif(collider.is_in_group("enemy")):
					ai_shoot.rpc(str(collider))
				elif(collider.is_in_group("target")):
				#get the parent of the target and call the despawn function
					target_shoot.rpc(str(collider))
				elif(collider.is_in_group("player")):
					enemy_shoot.rpc_id(collider.get_multiplayer_authority(), str(collider))
			
	#enemy_shoot.rpc_id(enemy_shoot.get_multiplayer_authority())
#have to find how to get the nodes relatice to the player
@rpc("call_local")
func move():
	$".".set_position($Camera3D/RayCast3D.get_collision_point()-Vector3(0,-1,0))
@rpc("call_local")
func ai_shoot(collider):
	#brcause the collider was outside of the player node scope, you get the node using a relative path from the grandparent
	get_parent().get_parent().get_node(collider).set_health(get_parent().get_parent().get_node(collider).get_health()-weapon_to_spawn.get_dmg())
@rpc("call_local")
func target_shoot(collider):
	get_parent().get_parent().get_node(collider).get_parent().get_parent().get_parent().despawn(get_node(collider))
@rpc("any_peer")
func enemy_shoot(collider):
	collider = get_parent().get_node(collider)
	#print(get_node(collider))
	collider.set_health(collider.get_health()-weapon_to_spawn.get_dmg())
	if(collider.get_health() <=0):
		collider.get_tree().change_scene_to_file("res://scenes/main.tscn")

func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		$".".rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity 

		if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
			$Camera3D.rotate_x(deg_to_rad(-x_delta))
			camera_x_rotation += x_delta 

#getters and setters for health etc...
func set_health(hp):
	health = hp
	
func get_health():
	return health
	
@rpc("call_local")
func equip_weapon():
	#placeholder code!!!!! the player will choose his gun at the main menu!! Delete later in production
	Global.set_weapon_id(1)
	
	#check which of the weapon in the game has the id of the weapon that the player has equiped and use that
	for weapon in weapons:
		
		if(weapon.instantiate().get_weapon_id_code() == Global.get_weapon_id()):
			weapon_to_spawn =  weapon.instantiate()
			
	weapon_holster.add_child(weapon_to_spawn)
