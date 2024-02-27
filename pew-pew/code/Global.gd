extends Node
#preload all the resourses
var test_floor =  preload("res://scenes/floor.tscn")
var test_wall =  preload("res://scenes/wall.tscn")
var test_prop = preload("res://scenes/prop.tscn")
var test_enemy = preload("res://scenes/enemy.tscn")
var enemy_drone001 = preload("res://scenes/drone_ground.tscn")
var test_map = preload("res://scenes/test_map.tscn")
var map1 = preload("res://scenes/map1.tscn")
var map2 = preload("res://scenes/map2.tscn")
var map3 = preload("res://scenes/map3.tscn")
var player = preload("res://scenes/player.tscn")
var env1 = preload("res://environments/environment1.tres")
var env2 = preload("res://environments/environment2.tres")
# Configure the UDP socket for receiving data from Python
var python_address : String = "127.0.0.1"
var python_port : int = 12345
var python_socket := PacketPeerUDP.new()
var data_list
var begin = false

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
