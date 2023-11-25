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
		
		# Process the received data as needed
		var decoded_data : String = data.get_string_from_utf8()
		
		data_list = decoded_data.split(",")
		print(data_list)
		begin = true
