extends Node
#preload all the resourses
#floors
var test_floor =  preload("res://scenes/floor.tscn")
#walls
var test_wall =  preload("res://scenes/wall.tscn")
var table = preload("res://scenes/wall.tscn")
var vending_machine = preload("res://scenes/vending machine.tscn")
var tree1 = preload("res://scenes/tree.tscn")
#props
var test_prop = preload("res://scenes/prop.tscn")
var barel_prop = preload("res://scenes/barel.tscn")
var bench_prop = preload("res://scenes/bench.tscn")
var metal_barel_prop = preload("res://scenes/metal_barel.tscn")
var fench_prop = preload("res://scenes/fench.tscn")
#target
var test_target = preload("res://scenes/target.tscn")
#enemies
var test_enemy = preload("res://scenes/enemy.tscn")
var enemy_drone001 = preload("res://scenes/drone_ground.tscn")
var enemy_drone002 = preload("res://scenes/drone_patrol.tscn")
var enemy_drone003 = preload("res://scenes/drone_sky.tscn")
var enemy_drone004 = preload("res://scenes/drone_wheels.tscn")
#maps
var test_map = preload("res://scenes/test_map.tscn")
var player = preload("res://scenes/player.tscn")
var env1 = preload("res://environments/environment1.tres")
#weapons
var test_weapon = preload("res://scenes/weapon.tscn")
# Configure the UDP socket for receiving data from Python
var python_address : String = "127.0.0.1"
var python_port : int = 12345
var env2 = preload("res://environments/environment2.tres")
var python_socket := PacketPeerUDP.new()
var data_list
var begin = false
var mouse = true
var weapon_id = null

func _ready():
	# Bind the socket to the specified address and port
	python_socket.bind(python_port, python_address)

func _process(delta):
	# Check for incoming data
	if python_socket.get_available_packet_count() > 0:
		# Receive data from Python
		#var data : PacketPeerUDP = python_socket.get_packet()
		var data = python_socket.get_packet()
	
		# Process the received data as needed
		var decoded_data : String = data.get_string_from_utf8()
		
		data_list = decoded_data.split(",")
		#print(data_list)
		begin = true
#setters and getters for if the player uses mouse and keyboard or not. Probably only for debugging
func set_mouse(m):
	mouse = m
func get_mouse():
	return mouse
#get and se the weapon that the player will use. The id will be set via the esp. Probably placeholder code for nows
func get_weapon_id():
	return(weapon_id)
func set_weapon_id(weapon):
	weapon_id = weapon
