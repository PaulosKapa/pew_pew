import socket
import time
# Server configuration
server_address = ('127.0.0.1', 12345)

# Create a socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to a specific address and port

#godot_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

server_socket.bind(server_address)

# Listen for incoming connections
server_socket.listen()
# Handle incoming data
#print(f"Server listening on {server_address}")

# Accept a connection from the client
client_socket, client_address = server_socket.accept()
#print(f"Connection established with {client_address}")

while True:
        # Receive data from the client
	data = client_socket.recv(1024)
        #if not data:
         #   break
	print(f"Received from client: {data.decode('utf-8')}")

        # Send a response back to the client
	response = "Hello from server!"
	server_socket.send(response.encode('utf-8'))
#        print(response)
