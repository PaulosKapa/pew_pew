import serial
from socket import socket, AF_INET, SOCK_DGRAM

# Configure the serial connection to your Arduino
arduino = serial.Serial('/dev/ttyUSB0', 9600)  # Adjust the port as needed


# Configure the UDP socket for communication with Godot
godot_address = ('127.0.0.1', 12345)  # Adjust the IP and port as needed
godot_socket = socket(AF_INET, SOCK_DGRAM)

while True:
    # Read data from Arduino
    print(arduino.readline())
    arduino_data = arduino.readline().decode('utf-8').strip()

    # Send data to Godot
    godot_socket.sendto(arduino_data.encode('utf-8'), godot_address)

