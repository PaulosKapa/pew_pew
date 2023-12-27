import serial
from serial import Serial
from socket import socket, AF_INET, SOCK_DGRAM
m_left = False
m_right = False
godot_address = ('127.0.0.1', 12345)  # Adjust the IP and port as needed
godot_socket = socket(AF_INET, SOCK_DGRAM)
try:
	ser = serial.Serial('COM4', 9600)
except:
	print("Mouse not found or disconnected.")
	k=input("Press any key to exit.")
while True:
	try:
	       # Setting Serial port number and baudrate

		dump = ser.readline()                           # Reading Serial port
		dump = str(dump)                                # Converting byte data into string
		dump = dump[2:-5]                               # Cleaning up the raw data recieved from serial port
		data = dump.split(',')                          # Spliting up the data to individual items in a list. the first item being the data identifier

		data_bytes = ','.join(data).encode('utf-8')

		print(data_bytes)
		godot_socket.sendto(data_bytes, godot_address)
		
            
	except (ValueError, IndexError):
		pass