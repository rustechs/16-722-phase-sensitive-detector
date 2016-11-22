#include <avr/io.h>
#include <avr/interrupt.h>

const int phaseLine = 2;
const uint8_t PSD = 1; //Enable or disable PSD modulation
volatile uint8_t tempMeas = 0;

void setup() {
  Serial.begin(115200);
  Serial.setTimeout(5000);

  // Set up external interrupt on phase line
  pinMode(phaseLine,INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(phaseLine), trigger, CHANGE);

  sei(); //Enable global interrupts
  
  // Wait here for handshake
  while(Serial.readString() != "foo");
  Serial.println("foo");
  
}

void loop() {
  // nothing to see here
}

void trigger(){

  // If phase is low, 
  if (digitalRead(phaseLine) == LOW) {
    // Read in from ADC
    tempMeas = uint8_t(analogRead(A5) >> 2); //divide by 4 to get 8bit reading
  } else {
    tempMeas = uint8_t(analogRead(A5) >> 2) - tempMeas;
    // Send over serial
    Serial.write(tempMeas);
  }
}



