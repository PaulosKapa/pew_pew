#include <Arduino.h>
#include <esp_now.h>
#include "WiFi.h"
#include <MPU6050_tockn.h>
#include <Wire.h>
//for the magazin
int magazinPin = 2;
int magazinInsertedPin = 3;
int magazineId;
int magazineVar;
int previousMagazineVar;
//shooting
int trigger = 4;
int ammo = 1;
int shooting;
//slide
int autoSlide = 5;
int manualSlide = 6;
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
  int magId;
};

void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  // Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success 1" : "Delivery Fail 1");
  // if (status ==0){
  //   Serial.println("Delivery Success 2");
  // }
  // else{
  //   Serial.println("Delivery fail 2");
  // }

  // Serial.println();
}
       


void setup() {
  analogReadResolution(AnalogReadResolution);
  //esp now
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
  //accelerometer
  Wire.begin();         // Initialise I2C communication
  mpu6050.begin();      // Initialise Gyro communication          
  OX = mpu6050.getAngleX(); // Getting angle X Y Z
  OY = mpu6050.getAngleY();
  OZ = mpu6050.getAngleZ(); 
  Serial.begin(115200);
  

}

void loop() {
  shooting = 0;
  // put your main code here, to run repeatedly:
  // Create an instance of the struct and assign values
  SensorData sensorData;
  magazineVar = digitalRead(magazinInsertedPin);
  //check if the magazin is inserted or not. If it is then read the potentiometer
  if(previousMagazineVar!=magazineVar){
    magazineId = analogLoading(magazinPin, magazineVar);
  }
  previousMagazineVar = magazineVar;
  
  if(digitalRead(trigger)==0 && ammo>0){
    shoot();
    shooting = 1;
    
  }
  if(ammo == 0){
    lock();
    if(autoSlide == 0 || manualSlide == 0){
      unlock();
    }
  }
  
  move();
  sensorData.magId = magazineId;
  sensorData.shot = shooting;
  sensorData.X = X;
  sensorData.Y = Y;
  sensorData.Z = Z;
  // Send message via ESP-NOW (size of an int is 4 bytes on ESP32)
    esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &sensorData, sizeof(sensorData));
   
    if (result == ESP_OK) {
      //Serial.println("Sent with success");
      Serial.println(String(sensorData.X) + ',' + String(sensorData.Y) + ',' + String(sensorData.Z) + ', ' + String(sensorData.shot));
    }
    else {
      Serial.println("Error sending the data");
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

//locking the slide when out of ammo
void lock(){
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, HIGH); 
  delay(100);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW); 
}

//unlock the slide
void unlock(){
  digitalWrite(motorPin1, HIGH);
  digitalWrite(motorPin2, LOW); 
  delay(100);
  digitalWrite(motorPin1, LOW);
  digitalWrite(motorPin2, LOW);
}

//movement
void move(){
  mpu6050.update();
  X = mpu6050.getAngleX() - (OX); // Getting angle X Y Z
  Y = mpu6050.getAngleY() - (OY);
  Z = mpu6050.getAngleZ() - (OZ);
  //Serial.println(String(X) + " " + String(Y) + " " + String(Z));
  

}
