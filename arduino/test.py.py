import serial
from serial import Serial
from pynput.mouse import Button, Controller

mouse = Controller()

# Adjust the serial port name as needed
ser = serial.Serial('COM3', 115200)

while True:
	try:
        # Read sensor data from Arduino
		line = ser.readline()
		print(line)
		#print(line)
		dump = str(line) 
		dump = dump[2:-5]
		values = dump.split(",")
#		print(values)
		mouse.move(int(values[1]), int(values[2]))
#	#	£if len(values) == 6:
            # Extract sensor data
	#	x_raw = values[0]
	#	y_raw = values[2]
	#	print(x_raw, y_raw)
		#
		#print(type(x_raw))
            # Perform mouse movement based on MPU6050 data
		#move_x = int(x_raw * 10)  # Adjust scaling factor as needed
		#move_y = int(y_raw * 10)  # Adjust scaling factor as needed
		#print(move_x, move_y)
         #   # Move the mouse cursor
	#	pyautogui.move((float(x_raw)-400.0)/200.0, -(float(y_raw)-200.0)/200.0)

	except (ValueError, IndexError):
		pass
