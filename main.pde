#include <SoftwareServo.h>
SoftwareServo myservo;  // create servo object to control a servo
SoftwareServo myservo2;
int goUp = 0;
int val = 0;
int wait = 0;
int flyFor = 0;
long flapTime = 0;
int angleMin = 0;
int angleMax = 120;
int upSpeed = 20;
int downSpeed = 1;
int buffer = 0;
//Sound variables
int potPin = 1;    // select the input pin for sound sensor
int ledPin = 13;   // select the pin for the LED
int soundVal = 0;
void setup()
{
  pinMode(ledPin, OUTPUT);  // declare the ledPin as an OUTPUT
  myservo.attach(2);  // attaches the servo on pin 2
  myservo2.attach(4);
  Serial.begin(9600);      // open the serial port at 9600 bps:
}
void loop()
{
  // Servo
  if (flyFor < flapTime){
    if (wait == 5){
      if (val < angleMin){
        goUp = 1;
        digitalWrite(ledPin,HIGH);
        }
      else if (val >angleMax){
        goUp = 0;
        digitalWrite(ledPin,LOW);
      }
      if (goUp == 0){
        val-=upSpeed;
      }else {
        val+=downSpeed;
      }
    }
    wait++;
    if (wait > 200)
      wait = 0;
    myservo.write(val);
// sets the servo position according to the scaled value
    myservo2.write(120-val);
    SoftwareServo::refresh();
    flyFor++;
  }else{
     //Sound
    soundVal = analogRead(potPin);
    Serial.println("Listening............");
    if( soundVal>1020 ){
      Serial.println("FREEAK OUT!");
      upSpeed = 15;
      downSpeed = 15;
      angleMax = 45;
      angleMin = 10;
      flapTime = 6000;
   }
    else if (soundVal<450 || soundVal >750){
      if (buffer == 0){
        Serial.println(soundVal);
        upSpeed = random (1, 20); //1 to 30
        downSpeed = random (1, 30);// 1 to 30
        angleMax = random (110, 120);
        angleMin = random (30, 45);
        flapTime = 10000 + random (5000 , 10000);
        flyFor = 0;
        buffer = 15;
      }else{
         buffer--;
      }
    }
  }
}