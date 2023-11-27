import socket

# Server address
server_address = ('127.0.0.1', 12345)

# Create a socket
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect to the server
client_socket.connect(server_address)
print(f"Connected to {server_address}")

try:
    while True:
        # Send data to the server
        message = input("Enter a message to send to the server (or type 'exit' to quit): ")
        client_socket.send(message.encode('utf-8'))

        if message.lower() == 'exit':
            break

        # Receive the server's response
        response = client_socket.recv(1024)
        print(f"Received from server: {response.decode('utf-8')}")

finally:
    # Clean up the connection
    print("Closing the connection.")
    client_socket.close()

