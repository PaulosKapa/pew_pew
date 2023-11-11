extends Node2D

var udp := PacketPeerUDP.new()
var connected = false

func _ready():
	OS.execute("python3",["test.py"])
	udp.connect_to_host("127.0.0.1", 12345)
	

func _process(delta):
	print(connected)
	if !connected:
		# Try to contact server
		udp.put_packet("The answer is... 42!".to_utf8_buffer())
	if udp.get_available_packet_count() > 0:
		print("Connected: %s" % udp.get_packet().get_string_from_utf8())
		connected = true
