extends Node

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
		print(data)
		begin = true
	if Input.is_action_just_pressed("enter"):
		var a : PackedByteArray = [1]
		print(a)
	
		python_socket.put_packet(a)

