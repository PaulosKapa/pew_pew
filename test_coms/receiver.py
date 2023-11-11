import socket

# Configure the UDP socket for receiving data from Godot
godot_address = ('127.0.0.1', 12345)  # Use the same IP and port as in the Godot script
godot_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
godot_socket.bind(godot_address)

while True:
    # Receive data from Godot
    data, address = godot_socket.recvfrom(1024)
    
    # Process the received data as needed
    decoded_data = data.decode('utf-8')
    print("Received data from Godot:", decoded_data)

