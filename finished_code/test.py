import serial
import time
from serial import Serial
from pynput.mouse import Button, Controller
from socket import socket, AF_INET, SOCK_DGRAM
import struct

m_left = False
m_right = False
godot_address = ('127.0.0.1', 12345)  # Adjust the IP and port as needed
godot_socket = socket(AF_INET, SOCK_DGRAM)

while True:
    try:
        data_bytes = struct.pack('!B', 1)  # Convert the integer to a bytes-like object
        print(data_bytes)
        godot_socket.sendto(data_bytes, godot_address)

    except (ValueError, IndexError):
        pass

