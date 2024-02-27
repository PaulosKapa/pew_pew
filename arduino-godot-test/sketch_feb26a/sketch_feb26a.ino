const int buttonPin = 2;
const int ledPin = 10;

int buttonState = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600); //make sure this is the same as the Baud Rate in Godot.

  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);
   digitalWrite(buttonPin, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
  buttonState = digitalRead(buttonPin);

  if(buttonState == LOW){
    Serial.println('1');

  }

  if(Serial.read() == '1'){
    digitalWrite(ledPin, HIGH);
  }

}