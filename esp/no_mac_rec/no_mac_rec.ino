#include <Arduino.h>
#include <esp_now.h>
#include "WiFi.h"
struct SensorData {
  int X;
  int Y;
  int Z;
};
int OX, OY, OZ;


// Callback when data is received
void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len) 
{
  // Create an instance of the struct
    SensorData sensorData;
    
  memcpy(&sensorData, incomingData, sizeof(sensorData));
  OX = sensorData.X;
  OY = sensorData.Y;
  OZ = sensorData.Z;
  
  

  
}

void setup()
{

  Serial.begin(9600);
  delay(100);

  Serial.println("Starting...\n");

  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  // print our mac address
  Serial.println(WiFi.macAddress());

  // Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    for(;;) {      delay(1);  } // do not initialize wait forever
  }
  
  Serial.println("initialized ESP-NOW");



  // Register for a callback function that will be called when data is received
  esp_now_register_recv_cb(OnDataRecv);

}

void loop()
{
  
  //Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z));
  Serial.println(String(OX) + ',' + String(OY) + ',' + String(OZ));
  
}