#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(7, 8); // CE, CSN

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
  Serial.begin(9600);
  radio.begin();
  radio.openReadingPipe(0, address);
  radio.setPALevel(RF24_PA_MIN);
  radio.startListening();
}

void loop() {

  if (radio.available()) {
    // Create an instance of the struct
    SensorData sensorData;

    // Read the entire struct from the radio
    radio.read(&sensorData, sizeof(sensorData));

    // Use the received data as needed
    Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z) + ',' + String(sensorData.mouse_input)+','+String(sensorData.teleporter));
  }
}
