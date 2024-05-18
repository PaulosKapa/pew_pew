#include <Arduino.h>
#include <esp_now.h>
#include "WiFi.h"
#include <MPU6050_tockn.h>
#include <Wire.h>
uint8_t broadcastAddress[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
int OX, OY, OZ;   // Angle Variables for calculating gyroscope zero error
int X, Y, Z;      // Data Variables for mouse co-ordinates
// Define a struct to hold all the variables
struct SensorData {
  int X;
  int Y;
  int Z;
};
MPU6050 mpu6050(Wire);
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success 1" : "Delivery Fail 1");
  if (status ==0){
    Serial.println("Delivery Success 2");
  }
  else{
    Serial.println("Delivery fail 2");
  }

  Serial.println();
}       

void setup()
{

  Serial.begin(115200);

  Serial.println("Starting...\n");

  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  Serial.println(WiFi.macAddress());

  // Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    for(;;) {      delay(1);  } // do not initialize wait forever
  }

  Serial.println("initialized ESP-NOW");


  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Trasnmitted packet
  esp_now_register_send_cb(OnDataSent);

   // Register peer
  esp_now_peer_info_t peerInfo;
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = 0;  
  peerInfo.encrypt = false;

   // Add peer        
  if (esp_now_add_peer(&peerInfo) != ESP_OK){
    Serial.println("Failed to add peer");
    for(;;) {      delay(1);  } // do not initialize wait forever
  } 
  Wire.begin();         // Initialise I2C communication
  mpu6050.begin();      // Initialise Gyro communication          
    OX = mpu6050.getAngleX(); // Getting angle X Y Z
  OY = mpu6050.getAngleY();
  OZ = mpu6050.getAngleZ(); 
}

int dataToSend = 1;
void loop()
{
    dataToSend++;
     mpu6050.update();
  X = mpu6050.getAngleX() - (OX); // Getting angle X Y Z
  Y = mpu6050.getAngleY() - (OY);
  Z = mpu6050.getAngleZ() - (OZ);


  // Create an instance of the struct and assign values
  SensorData sensorData;
  sensorData.X = X;
  sensorData.Y = Y;
  sensorData.Z = Z;




    // Send message via ESP-NOW (size of an int is 4 bytes on ESP32)
    esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &sensorData, sizeof(sensorData));
   
    if (result == ESP_OK) {
      Serial.println("Sent with success");
    }
    else {
      Serial.println("Error sending the data");
    }
     Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z));

    //Serial.println(WiFi.macAddress());    
    // delay(1000);
}