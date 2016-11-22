#include <avr/io.h>
#include <avr/interrupt.h>

const int phaseLine = 12;

const uint8_t PSD = 1; //Enable or disable the PSD modulation
volatile uint8_t phase = 0;

void setup() {
  Serial.begin(115200);
  Serial.setTimeout(5000);
  pinMode(phaseLine,OUTPUT);

  // Set up 8-bit Fast-PWM using Timer0
  // Output A maps to PD6, or A3/Pin17 on the Arduino Board
  DDRD |= (1 << DDD6);
  OCR0A = 0; //Duty cycle
  TCCR0A |= (1 << COM0A1);
  TCCR0A |= (1 << WGM01) | (1 << WGM00);
  TCCR0B |= (1 << CS01);

  // Set up Timer1 for overflow interrupt as time-base
  TIMSK1 = (1 << TOIE1);
  // Prescale Timer1 clock by 8, set to CTC mode
  TCCR1B |= (1 << WGM12)|(1 << CS11);

  // Set counter value
  OCR1A = 122;

  // Reset counter
  TCNT1 = 0x00; 

  sei(); // Enable global interrupts

  // Wait here for handshake
  while(Serial.readString() != "foo");
  Serial.println("foo");

  // Enable Timer1 compare interrupt
  TIMSK1 |= (1 << OCIE1A);
}

void loop() {
  // Nothing to see here
}


ISR(TIMER1_COMPA_vect){
  uint8_t output = 0;

  // Only read in next value when phase is low
  if (!phase && Serial.available()) {
    output = Serial.read();
  }
  
  if (PSD) { // if PSD modulation is enabled
    output *= phase; //Modulate output appropriately
  }
  
  OCR0A = output; // Update DAC value
  
  phase ^= (1<<0); // Toggle phase state (LSB)
}
