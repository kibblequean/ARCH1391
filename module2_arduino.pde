//Smoothing code referenced from: http://www.arduino.cc/en/Tutorial/Smoothing
//By David A. Mellis  <dam@mellis.org>
//Servo movement based on Examples > Servo > Knob
//By Michael Rinott <http://people.interaction-ivrea.it/m.rinott>
//
//This code uses the above codes as starting points, but have been adapted for the particular uses of this project
//Rotates servos according to serial data received from Processing
//By Rosemarie Still 22nd October 2011


#include <Servo.h> 
 
Servo myservo1;  // create servo object to control a servo
Servo myservo2;  // create second servo object

int rawSerial;
int servoAngle = 0;
boolean moveNow = false;

void setup()
{
  // initialize serial communication with computer:
  Serial.begin(9600);                   
   
  myservo1.attach(9);  // attaches the servo on pin 9 to myservo1
  myservo2.attach(10); // attaches the servo on pin 10 to myservo2  
}

void loop() {
  if (Serial.available()) {
   
   //read serial data
   rawSerial = Serial.read(); 
   Serial.print(rawSerial, DEC);
   Serial.println();
   
   //map received serial data to an angle for servo rotation
   servoAngle = map(rawSerial, 0, 9, 0, 180);   
  }
   
   myservo1.write(servoAngle);                  // sets myservo1 position according to the scaled value 
   myservo2.write(servoAngle);                  // sets myservo2 position according to the scaled value
}
