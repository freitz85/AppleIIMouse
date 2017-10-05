#include "Arduino.h"
#include "HardwareSerial.h"
#include "PS2Mouse.h"

PS2Mouse::PS2Mouse(int data_pin, int clock_pin)
{
  _data_pin = data_pin;
  _clock_pin = clock_pin;
}

/*
 * according to some code I saw, these functions will
 * correctly set the mouse clock and data pins for
 * various conditions.
 */
void PS2Mouse::gohi(int pin)
{
  pinMode(pin, INPUT);
  digitalWrite(pin, HIGH);
}

void PS2Mouse::golo(int pin)
{
  pinMode(pin, OUTPUT);
  digitalWrite(pin, LOW);
}

void PS2Mouse::write(char data)
{
  char i;
  char parity = 1;

  //  Serial.print("Sending ");
  //  Serial.print(data, HEX);
  //  Serial.print(" to mouse\n");
  //  Serial.print("RTS");
  /* put pins in output mode */
  gohi(_data_pin);
  gohi(_clock_pin);
  delayMicroseconds(300);
  golo(_clock_pin);
  delayMicroseconds(300);
  golo(_data_pin);
  delayMicroseconds(10);
  /* start bit */
  gohi(_clock_pin);
  /* wait for mouse to take control of clock); */
  while (digitalRead(_clock_pin) == HIGH)
    ;
  /* clock is low, and we are clear to send data */
  for (i=0; i < 8; i++) {
    if (data & 0x01) {
      gohi(_data_pin);
    } 
    else {
      golo(_data_pin);
    }
    /* wait for clock cycle */
    while (digitalRead(_clock_pin) == LOW)
      ;
    while (digitalRead(_clock_pin) == HIGH)
      ;
    parity = parity ^ (data & 0x01);
    data = data >> 1;
  }  
  /* parity */
  if (parity) {
    gohi(_data_pin);
  } 
  else {
    golo(_data_pin);
  }
  while (digitalRead(_clock_pin) == LOW)
    ;
  while (digitalRead(_clock_pin) == HIGH)
    ;
  /* stop bit */
  gohi(_data_pin);
  delayMicroseconds(50);
  while (digitalRead(_clock_pin) == HIGH)
    ;
  /* wait for mouse to switch modes */
  while ((digitalRead(_clock_pin) == LOW) || (digitalRead(_data_pin) == LOW))
    ;
  /* put a hold on the incoming data. */
  golo(_clock_pin);
  //  Serial.print("done.\n");
}

/*
 * Get a byte of data from the mouse
 */
char PS2Mouse::read(void)
{
  char data = 0x00;
  int i;
  char bit = 0x01;

  //  Serial.print("reading byte from mouse\n");
  /* start the clock */
  gohi(_clock_pin);
  gohi(_data_pin);
  delayMicroseconds(50);
  while (digitalRead(_clock_pin) == HIGH)
    ;
  delayMicroseconds(5);  /* not sure why */
  while (digitalRead(_clock_pin) == LOW) /* eat start bit */
    ;
  for (i=0; i < 8; i++) {
    while (digitalRead(_clock_pin) == HIGH)
      ;
    if (digitalRead(_data_pin) == HIGH) {
      data = data | bit;
    }
    while (digitalRead(_clock_pin) == LOW)
      ;
    bit = bit << 1;
  }
  /* eat parity bit, which we ignore */
  while (digitalRead(_clock_pin) == HIGH)
    ;
  while (digitalRead(_clock_pin) == LOW)
    ;
  /* eat stop bit */
  while (digitalRead(_clock_pin) == HIGH)
    ;
  while (digitalRead(_clock_pin) == LOW)
    ;

  /* put a hold on the incoming data. */
  golo(_clock_pin);
  //  Serial.print("Recvd data ");
  //  Serial.print(data, HEX);
  //  Serial.print(" from mouse\n");
  return data;
}

void PS2Mouse::init()
{
  gohi(_clock_pin);
  gohi(_data_pin);
  //  Serial.print("Sending reset to mouse\n");
  write(0xff);
  read();  /* ack byte */
  //  Serial.print("Read ack byte1\n");
  read();  /* blank */
  read();  /* blank */
  //  Serial.print("Sending remote mode code\n");
  write(0xf0);  /* remote mode */
  read();  /* ack */
  //  Serial.print("Read ack byte2\n");
  delayMicroseconds(100);
}



