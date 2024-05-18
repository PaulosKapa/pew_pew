#include <MPU6050_tockn.h>
#include <Wire.h>
#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(7, 8); // CE, CSN
int LeftB = 3;    // Left Button Pin
int RightB = 2;
MPU6050 mpu6050(Wire);
int mouse_input;
int teleporter;
int X, Y, Z;      // Data Variables for mouse co-ordinates
int OX, OY, OZ;   // Angle Variables for calculating gyroscope zero error

// Define a struct to hold all the variables
struct SensorData {
  int X;
  int Y;
  int Z;
  int mouse_input;
  int teleporter;
};

const byte address[6] = "00001";

void setup() {
  radio.begin();
  radio.openWritingPipe(address);
  radio.setPALevel(RF24_PA_MIN);
  radio.stopListening();
  Serial.begin(9600); // Initialise Serial communication
  Wire.begin();         // Initialise I2C communication
  mpu6050.begin();      // Initialise Gyro communication
  Serial.println("STRTM"); // Identifier "STARTM" for start mouse
  radio.write(&"STRTM", sizeof("STRTM"));
  mpu6050.calcGyroOffsets(true); // Setting Gyro offsets
  //mpu6050.update(); // Command to calculate the sensor data before using the get command
  OX = mpu6050.getAngleX(); // Getting angle X Y Z
  OY = mpu6050.getAngleY();
  OZ = mpu6050.getAngleZ();
  Serial.println(String(OX) + ',' + String(OY) + ',' + String(OZ));
  pinMode(LeftB, INPUT); // Setting Pinmode for all three buttons as INPUT
  digitalWrite(LeftB, HIGH);
  pinMode(RightB, INPUT); // Setting Pinmode for all three buttons as INPUT
  digitalWrite(RightB, HIGH);
  

}

void loop() {
  mpu6050.update();
  X = mpu6050.getAngleX() - (OX); // Getting angle X Y Z
  Y = mpu6050.getAngleY() - (OY);
  Z = mpu6050.getAngleZ() - (OZ);
  mouse_input = digitalRead(LeftB);
  teleporter = digitalRead(RightB);

  // Create an instance of the struct and assign values
  SensorData sensorData;
  sensorData.X = X;
  sensorData.Y = Y;
  sensorData.Z = Z;
  sensorData.mouse_input = mouse_input;
  sensorData.teleporter = teleporter;

  // Send the entire struct using radio.write
  radio.write(&sensorData, sizeof(sensorData));

  // Mouse movement resolution delay
  Serial.println(String(X) + ',' + String(Y) + ',' + String(Z) + ',' + String(mouse_input) + ',' + String(teleporter)); // Sends corrected gyro data to the Serial Port with the identifier "DATAL"
  delay(15);
}