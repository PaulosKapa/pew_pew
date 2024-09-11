/*
    ESP-NOW Broadcast Slave
    Lucas Saavedra Vaz - 2024

    This sketch demonstrates how to receive broadcast messages from a master device using the ESP-NOW protocol.

    The master device will broadcast a message every 5 seconds to all devices within the network.

    The slave devices will receive the broadcasted messages. If they are not from a known master, they will be registered as a new master
    using a callback function.
*/

#include "ESP32_NOW.h"
#include "WiFi.h"

#include <esp_mac.h>  // For the MAC2STR and MACSTR macros

#include <vector>

int inputVar = 0;
struct SensorData {
  int X;
  int Y;
  int Z;
  int shot;
  int gunId;
  int unlock;
  int actions;
  int magId;
  int shootingMode;
  
};
SensorData sData;

struct varData{
  int inputVar;
};

uint8_t senderAddress[6]; // To store the sender's MAC address

// Updated callback function with the correct signature
void OnDataRecv(const esp_now_recv_info *recvInfo, const uint8_t *incomingData, int len) {
  // Cast the incoming data to the correct structure type
  SensorData sensorData;
  memcpy(&sensorData, incomingData, sizeof(sensorData));  // Correctly copy incoming data to the structure
  
  Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z)+ ',' +String(sensorData.shot) + ',' +  String(sensorData.actions) + ',' +String(sensorData.magId) +',' +String(sensorData.gunId) + ',' + String(sensorData.shootingMode) +','+String(sensorData.unlock));
  // Save the sender's MAC address for replying
  memcpy(senderAddress, recvInfo->src_addr, 6);

  // Add the sender as a peer if not already added
  if (!esp_now_is_peer_exist(senderAddress)) {
    esp_now_peer_info_t peerInfo;
    memset(&peerInfo, 0, sizeof(peerInfo));
    memcpy(peerInfo.peer_addr, senderAddress, 6);
    peerInfo.channel = 0;  
    peerInfo.encrypt = false;

    if (esp_now_add_peer(&peerInfo) != ESP_OK) {
      Serial.println("Failed to add peer");
    } else {
      Serial.println("Peer added successfully");
    }
  }
}
    

void setup() {
  Serial.begin(115200);
  

  // Initialize the Wi-Fi module
  WiFi.mode(WIFI_STA);
 // Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Register the receive callback function
  esp_now_register_recv_cb(OnDataRecv);
}


varData vData;
void loop() {
  if (Serial.available()>0) {
    // Read the incoming serial data
    String serialData = Serial.readStringUntil('\n');
    serialData.trim(); // Remove any trailing whitespace or newline characters

    // Process the serial data
    if (serialData.length()>0) {
      // Split the serial data into individual components
      int commaIndex = serialData.indexOf(',');
      if (commaIndex != -1) {
        String messageStr = serialData.substring(0, commaIndex);
        String positionStr = serialData.substring(commaIndex + 1);

        int message = messageStr.toInt();
        int position = positionStr.toInt();
        switch(position){
          case 9:
            vData.inputVar = message;
            
            break;
        }
      }
       // Send data to the last sender's MAC address
    esp_err_t result = esp_now_send(senderAddress, (uint8_t *) &vData, sizeof(vData));

    if (result == ESP_OK) {
      Serial.println("Sent successfully");
    } else {
      Serial.print("Error sending the data: ");
      Serial.println(result);  // Print the error code for further diagnostics
    }


    }
  //       // // Process the message and position values
  //       // Serial.print("Received from serial: ");
  //       // Serial.print("Message = ");
  //       // Serial.print(message);
  //       // Serial.print(", Position = ");
  //       // Serial.println(position);
        

  //       // Implement your logic here to handle the message and position values
  //     }
  //   }
  // }
  //sData.inputVar = inputVar;
//Serial.println(String(sData.X) + ',' + String(sData.Y) + ',' + String(sData.Z)+ ',' +String(sData.shot) + ',' +  String(sData.actions) + ',' +String(sData.magId) +',' +String(sData.gunId) + ',' + String(sData.shootingMode) +','+String(sData.unlock));// +','+String(sData.inputVar));
}
}