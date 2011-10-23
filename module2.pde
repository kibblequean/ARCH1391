//
// ControlP5 button. 
// by andreas schlegel, 2009
//
// This code creates a visualisation that compares two search terms using pre-loaded Google Trends data.
// By Rosemarie Still 22nd October 2011


import controlP5.*;
import processing.serial.*;

ControlP5 controlP5;
Serial serial;

// this is only a note.
// we will not use variable b in the code below.
// we have to use controlP5.Button here since there
// would be a conflict if we only use Button to declare button b.
Button b;

// a button-controller with name buttonValue will change the
// value of this variable when pressed.
int buttonValue = 0;

String name1 = "First Search Term";
String name2 = "Second Search Term";

// counters to check if a name has been selected
int name1Counter = 0;
int name2Counter = 0;

// array to store Google Trends data
float[] name1numbers = new float[405];
float[] name2numbers = new float[405];

float[] calculations = new float[405];
float[] calculationsMapped = new float[405];
float[] calculationsServo = new float[405];
int[] calculationsServoInt = new int[405];

boolean drawNow = false;
boolean cleared = true;

float circleX1 = 0;
float circleY1 = 300;
float circleR = 3;
float circleX2 = 0;
float circleY2 = 300;
int index = 0;

float timelineX = 0;
float timelineY = 350;
float timelineYear = 0;
float timelineSpacing = 39.1;
float timelineTextSpacing = timelineSpacing;
int timelineText = 2004;

void setup() {
  size(1212,480);
  
  println(Serial.list());
  String port = Serial.list()[0];
  serial = new Serial(this, port, 9600);
  
  colorMode(HSB);
  background(255);
  smooth();
  frameRate(30);
  
  fill(0);
  text("Choose one:", 0, 20);
  text("Choose one:", 150, 20);
  
  controlP5 = new ControlP5(this);
  controlP5.addButton("Lady_Gaga",0,0,30,100,30);
  controlP5.addButton("Eminem",0,0,65,100,30);
  controlP5.addButton("The_Beatles",0,0,100,100,30);
  
  controlP5.addButton("Obama",0,150,30,100,30);
  controlP5.addButton("Global_Warming",0,150,65,100,30);
  controlP5.addButton("Jesus",0,150,100,100,30);
  
  controlP5.addButton("Calculate" ,0, 500,30,100,30);
  controlP5.addButton("Clear" ,0, 605,30,100,30);
  
  // set up timeline
  line(0, 350, width, 350);
  
  for (int i = 0; i < 32; i++) {
    line(timelineX, timelineY, timelineX, timelineY-5);
    timelineX = timelineX + timelineSpacing;
  }
  for (int i = 0; i < 8; i++) {
    line(timelineYear, timelineY, timelineYear, timelineY+15);
    timelineYear = timelineYear + timelineSpacing*4;
  }
  fill(0);
  textAlign(CENTER, TOP);
  for (int i = 0; i <8; i++) {  
    text(timelineText, timelineTextSpacing*2, timelineY+3);
    timelineTextSpacing = timelineTextSpacing + timelineSpacing*2;
    timelineText++;
  }
  
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().name());
}

// when a button is pressed, the CSV data is loaded, converted from a string to a float, and put into an array

public void Lady_Gaga(int theValue) {
  String numsLadyGaga[] = loadStrings("lady_gaga.csv");
  for (int i = 0; i < numsLadyGaga.length; i++) {
    name1numbers[i] = float(numsLadyGaga[i]);
  }
  println(name1numbers);
    name1 = "Lady Gaga";
    name1Counter++;
}

public void Eminem(int theValue) {
  String numsEminem[] = loadStrings("eminem.csv");
  for (int i = 0; i < numsEminem.length; i++) {
    name1numbers[i] = float(numsEminem[i]);
  }
  println(name1numbers);
    name1 = "Eminem";
    name1Counter++;
}

public void The_Beatles(int theValue) {
  String numsTheBeatles[] = loadStrings("the_beatles.csv");
  for (int i = 0; i < numsTheBeatles.length; i++) {
    name1numbers[i] = float(numsTheBeatles[i]);
  }
  println(name1numbers);
    name1 = "The Beatles";
    name1Counter++;
}

public void Obama(int theValue) {
  String numsObama[] = loadStrings("obama.csv");
  for (int i = 0; i < numsObama.length; i++) {
    name2numbers[i] = float(numsObama[i]);
  }
  println(name2numbers);
    name2 = "Obama";
    name2Counter++;
}

public void Global_Warming(int theValue) {
  String numsGlobalWarming[] = loadStrings("global_warming.csv");
  for (int i = 0; i < numsGlobalWarming.length; i++) {
    name2numbers[i] = float(numsGlobalWarming[i]);
  }
  println(name2numbers);
    name2 = "Global Warming";
    name2Counter++;
}

public void Jesus(int theValue) {
  String numsJesus[] = loadStrings("jesus.csv");
  for (int i = 0; i < numsJesus.length; i++) {
    name2numbers[i] = float(numsJesus[i]);
  }
  println(name2numbers);
    name2 = "Jesus";
    name2Counter++;
}


//calculate the difference between name1 and name2
public void Calculate(int theValue) {
  if (name1Counter > 0 && name2Counter > 0) {
    for (int i = 0; i < 405; i++) {
      calculations[i] = name1numbers[i] - name2numbers[i];
      if(calculations[i] < 0) {
        calculations[i] = calculations[i]*-1;
      }
    }
    //start drawing visualisation
    drawNow = true;
  }
  
  //map calculation array to achieve best saturation contrast in visualisation
  for (int i = 0; i < calculations.length; i++) {
    calculationsMapped[i] = map(calculations[i], 0, 160, 0, 255);
  }
  
  //map calculation array to a single digit for sending to serial port to avoid jumbling of numbers
  for (int i = 0; i < calculations.length; i++) {
    calculationsServo[i] = map(calculations[i], 0, 160, 0, 9);
    
    //round float to whole number and convert to int
    calculationsServo[i] = round(calculationsServo[i]);
    calculationsServoInt[i] = int(calculationsServo[i]);
    
    //set upper limit to scale down any disporportionately large numbers
    if (calculationsServo[i] > 9) {
      calculationsServo[i] = 9;
    }
  }
}

//when the clear button is pressed, the visualisation will be cleared
public void Clear(int theValue) {
  fill(255);
  noStroke();
  rect(0,100, width,230);
  cleared = true;
}

void draw() {
  noStroke();
  fill(255);
  rect(290,0,150,100);
  
  fill(0);
  textAlign(LEFT);
  fill(0,255,255);
  text(name1, 300, 45);
  fill(150,255,255);
  text(name2, 300, 65);
  fill(0);
  
  //draw line graph 
  if (drawNow && cleared) {
        
    if(index < 404) {
      circleX1 = circleX1 + circleR;
      //change saturation of fill colour based on calculated number difference
      fill(0, 255-calculationsMapped[index], 255);
      circleY1 = 300 - name1numbers[index];
      ellipse(circleX1, circleY1, circleR, circleR);
            
      circleX2 = circleX2 + circleR;
      fill(150, 255-calculationsMapped[index], 255);
      circleY2 = 300 - name2numbers[index];
      ellipse(circleX2, circleY2, circleR, circleR);
      
      //send scaled calculations to the serial port
      serial.write(calculationsServoInt[index]);
      println(calculationsServoInt[index]);
      
      index = index + 1;
      
      //stop drawing and reset starting position when entire visualisation is complete      
      if(index == 404) {
        drawNow = false;
        cleared = false;
        circleX1 = 0;
        circleY1 = 300;
        circleX2 = 0;
        circleY2 = 300;
        index = 0;
      }
      delay(100);
    }
  }
}
