//Smoothing code referenced from: http://www.arduino.cc/en/Tutorial/Smoothing
//By David A. Mellis  <dam@mellis.org>
//Servo movement based on Examples > Servo > Knob
//By Michael Rinott <http://people.interaction-ivrea.it/m.rinott>
//
//This code uses the above codes as starting points, but have been adapted for the particular uses of this project
//By Rosemarie Still 22nd August 2011


#include <Servo.h> 
 
Servo myservo1;  // create servo object to control a servo
Servo myservo2;  // create second servo object

const int numReadings = 400; // number of samples to keep track of

int readings[numReadings];      // the readings from the analog input
int index = 0;                  // the index of the current reading
long total = 0;                  // the running total
int average = 0;                // the average

int inputPin = A0;

void setup()
{
  // initialize serial communication with computer:
  Serial.begin(9600);                   
  // initialize all the readings to 0: 
  for (int thisReading = 0; thisReading < numReadings; thisReading++)
    readings[thisReading] = 0;  
  myservo1.attach(9);  // attaches the servo on pin 9 to myservo1
  myservo2.attach(10); // attaches the servo on pin 10 to myservo2
}

void loop() {
  // subtract the last reading:
  total= total - readings[index];         
  // read from the sensor:  
  readings[index] = analogRead(inputPin); 
  // add the reading to the total:
  total= total + readings[index];       
  // advance to the next position in the array:  
  index = index + 1;                    

  // if we're at the end of the array...
  if (index >= numReadings)              
    // ...wrap around to the beginning: 
    index = 0;                           

  // calculate the average:
  average = (total / numReadings);         
  // send it to the computer (as ASCII digits) 
  Serial.println(average, DEC);  

  average = map(average, 20, 100, 0, 200);     // scale it to use it with the servo (value between 0 and 180) 
  myservo1.write(average);                  // sets myservo1 position according to the scaled value 
  myservo2.write(average);                  // sets myservo2 position according to the scaled value
  delay(15);                           // waits for the servo to get there 
}
