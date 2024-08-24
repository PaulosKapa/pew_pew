#include <Arduino.h>
#include <ESP32_NOW.h>
#include "WiFi.h"
#include <MPU6050_tockn.h>
#include <Wire.h>
#include <esp_mac.h>  // For the MAC2STR and MACSTR macros

//gun id and shooting mode
int gunId = 1;
//1: semi, 2: burst, 3: auto, 4 semi+ burst, 5: semi + auto, 6: semi + burst + auto, 7: burst + auto, 9: pump/bolt, 9: laser
int shootingMode = 1;
//for the magazin
int magazinPin = 2;
int magazinInsertedPin = 3;
int magazineId;
int magazineVar;
int previousMagazineVar;
//shooting
int trigger = 4;
int ammo;
int shooting;
int sMode;
//slide
int autoSlide = 5;
int manualSlide = 6;
int unlocking = 0;
//transporting
int action = 7;
int transporting;
//barrel
int motorPin1 = 38; 
int motorPin2 = 36; 
//accelerometer
int OX, OY, OZ;   // Angle Variables for calculating gyroscope zero error
int X, Y, Z;      // Data Variables for mouse co-ordinates
MPU6050 mpu6050(Wire);
//analog read resolution
int AnalogReadResolution = 10;
//esp now
uint8_t broadcastAddress[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
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

/* Definitions */
#define ESPNOW_WIFI_CHANNEL 6
// Creating a new class that inherits from the ESP_NOW_Peer class is required.

class ESP_NOW_Broadcast_Peer : public ESP_NOW_Peer {
public:
  // Constructor of the class using the broadcast address
  ESP_NOW_Broadcast_Peer(uint8_t channel, wifi_interface_t iface, const uint8_t *lmk) : ESP_NOW_Peer(ESP_NOW.BROADCAST_ADDR, channel, iface, lmk) {}

  // Destructor of the class
  ~ESP_NOW_Broadcast_Peer() {
    remove();
  }

  // Function to properly initialize the ESP-NOW and register the broadcast peer
  bool begin() {
    if (!ESP_NOW.begin() || !add()) {
      log_e("Failed to initialize ESP-NOW or register the broadcast peer");
      return false;
    }
    return true;
  }

  // Function to send a message to all devices within the network
  bool send_message(const uint8_t *data, size_t len) {
    if (!send(data, len)) {
      log_e("Failed to broadcast message");
      return false;
    }
    return true;
  }
};

/* Global Variables */

uint32_t msg_count = 0;

// Create a broadcast peer object
ESP_NOW_Broadcast_Peer broadcast_peer(ESPNOW_WIFI_CHANNEL, WIFI_IF_STA, NULL);

void setup() {
  Serial.begin(115200);
//   while (!Serial) {
//      delay(10);
//  }

  // Initialize the Wi-Fi module
  WiFi.mode(WIFI_STA);
  WiFi.setChannel(ESPNOW_WIFI_CHANNEL);
  while (!WiFi.STA.started()) {
    delay(100);
  }

  Serial.println("ESP-NOW Example - Broadcast Master");
  Serial.println("Wi-Fi parameters:");
  Serial.println("  Mode: STA");
  Serial.println("  MAC Address: " + WiFi.macAddress());
  Serial.printf("  Channel: %d\n", ESPNOW_WIFI_CHANNEL);

  // Register the broadcast peer
  if (!broadcast_peer.begin()) {
    Serial.println("Failed to initialize broadcast peer");
    Serial.println("Reebooting in 5 seconds...");
    delay(5000);
    ESP.restart();
  }
    //magazin
  pinMode(magazinInsertedPin, INPUT_PULLUP);
  pinMode(magazinPin, INPUT);
  //read the magazine when setting up
  magazineId = analogLoading(magazinPin, magazineVar);
  //shooting
  pinMode(trigger, INPUT_PULLUP);
  //barrel
  pinMode(motorPin1, OUTPUT);
  pinMode(motorPin2, OUTPUT);
  //slide
  pinMode(autoSlide, INPUT_PULLUP);
  pinMode(manualSlide, INPUT_PULLUP);
  //transporting
  pinMode(action, INPUT_PULLUP);
  //accelerometer
  Wire.begin();         // Initialise I2C communication
  mpu6050.begin();      // Initialise Gyro communication          
  OX = mpu6050.getAngleX(); // Getting angle X Y Z
  OY = mpu6050.getAngleY();
  OZ = mpu6050.getAngleZ(); 
  Serial.begin(115200);
  analogReadResolution(AnalogReadResolution);
  Serial.println("Setup complete.");
  
}

void loop() {
  
  shooting = 0;
  transporting = 0;
  // put your main code here, to run repeatedly:
  // Create an instance of the struct and assign values
  SensorData sensorData;
  magazineVar = digitalRead(magazinInsertedPin);
  //check if the magazin is inserted or not. If it is then read the potentiometer
  if(previousMagazineVar!=magazineVar){
    magazineId = analogLoading(magazinPin, magazineVar);
  }
  previousMagazineVar = magazineVar;
  if(digitalRead(action)==0){
    transporting = transport();
  }
  if(digitalRead(trigger)==0 && ammo>0){
    shooting = shoot();
    
  }
  if(ammo == 0){
    unlocking = lock();
    if(digitalRead(autoSlide) == 0 || digitalRead(manualSlide) == 0){
      unlocking = unlock();
    }
  }
  if(digitalRead(action) == 0){
    transporting = transport();
  }
  
  move();
  sensorData.shootingMode = shootingMode;
  sensorData.gunId = gunId;
  sensorData.shot = shooting;
  sensorData.unlock = unlocking;
  sensorData.actions = transporting;
  sensorData.X = X;
  sensorData.Y = Y;
  sensorData.Z = Z;
  sensorData.magId = magazineId;
  
  // Send message via ESP-NOW (size of an int is 4 bytes on ESP32)
 Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z)+ ',' +String(sensorData.shot) + ',' +  String(sensorData.actions) + ',' +String(sensorData.magId) +',' +String(sensorData.gunId) + ',' + String(sensorData.shootingMode) +','+String(sensorData.unlock));
  //char data[32];
  //snprintf(data, sizeof(data),String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z)+ ',' +String(sensorData.shot) + ',' +  String(sensorData.actions) + ',' +String(sensorData.magId) +','+String(sensorData.unlock));

  if (!broadcast_peer.send_message((uint8_t *) &sensorData, sizeof(sensorData))) {
    Serial.println("Failed to broadcast message");
  }
}

//function for reading what part we have inserted (what magazine for example)
//depending on the pin we use, it is a different 
int analogLoading(int pin, int dataVar){
  int multisampling = 0;
  int result = 0;
  //when no attachment
  if(dataVar == 1){
    result = 0;
  }
  //when yes attachment
  if(dataVar == 0){
     //multisampling is important if we want to have good readings
      for(int i = 0; i<7000; i++){
     
        multisampling = (multisampling+analogRead(pin));
      }
      result = (multisampling/70000);
      
  }
  return(result);
}

//shooting
int shoot(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH); 
  delay(100);
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW); 
  return 1;
}

int transport(){
  return 1;
}

//locking the slide when out of ammo
int lock(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH); 
  delay(100);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW); 
  return 1;
}

//unlock the slide
int unlock(){
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW); 
  delay(100);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
  return 0;
}

//movement
void move(){
  mpu6050.update();
  X = mpu6050.getAngleX() - (OX); // Getting angle X Y Z
  Y = mpu6050.getAngleY() - (OY);
  Z = mpu6050.getAngleZ() - (OZ);
  //Serial.println(String(X) + " " + String(Y) + " " + String(Z));
}
