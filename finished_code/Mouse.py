# This Python code is an extension script for the Air Mouse using Arduino and MPU6050.
# Visit the Github page for the Arduino code and other information related to the project.
# https://github.com/rupava/Air-Mouse-Using-Arduino-and-MPU6050
# -By Rupava Baruah


import serial
from serial import Serial
from pynput.mouse import Button, Controller
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
mouse = Controller()
while True:
	try:
	       # Setting Serial port number and baudrate

		dump = ser.readline()                           # Reading Serial port
		dump = str(dump)                                # Converting byte data into string
		dump = dump[2:-5]                               # Cleaning up the raw data recieved from serial port
		data = dump.split(',')                          # Spliting up the data to individual items in a list. the first item being the data identifier
		print(data)
     
		#mouse.move(int(data[0]), int(data[2]))        # Moving the mouse by using the X and Y values after converting them into integer
        
      #
	#	if int(data[3]) == 0:                     # If the Left button is pressed
	#		m_left = True
	#		mouse.press(Button.left)                # The corresponding button is pressed and released
			
	#	if int(data[3]) == 1 and m_left == True:                     # If the Left button is pressed

#			              # The corresponding button is pressed and released
#			mouse.release(Button.left)
#			m_left = False
#		if int(data[4]) == 0:                     # If the Left button is pressed#3
#			mouse.press(Button.left)   
#			m_right = True             # The corresponding button is pressed and released
			
#		if int(data[4]) == 1 and m_right == True:                     # If the Left button is pressed
#
#			              # The corresponding button is pressed and released
#			mouse.release(Button.left)
#			m_right = False
#

		data_bytes = ','.join(data).encode('utf-8')

        
		godot_socket.sendto(data_bytes, godot_address)
		
            
	except (ValueError, IndexError):
		pass