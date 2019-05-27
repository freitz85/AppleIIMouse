#include "PS2Mouse.h"

#define RW        A3
#define CB2       2
#define ADD0      A0
#define ADD1      A1
#define ADD2      A2
#define ADD3      A3
#define PS2_CLK   3
#define PS2_DATA  12
#define IRQ       A5
#define DATA0     8
#define DATA1     9
#define DATA2     10
#define DATA3     11
#define DATA4     4
#define DATA5     5
#define DATA6     6
#define DATA7     7
#define WRITE     0x80
#define LED       13

#define WRITE_X   0
#define WRITE_Y   1
#define WRITE_X_LOW_BOUND 2
#define WRITE_X_HIGH_BOUND 3
#define WRITE_Y_LOW_BOUND 4
#define WRITE_Y_HIGH_BOUND 5
#define WRITE_MODE 6
#define SET_INPUT 7
#define READ_X   8
#define READ_Y   9
#define READ_X_LOW_BOUND 10
#define READ_X_HIGH_BOUND 11
#define READ_Y_LOW_BOUND 12
#define READ_Y_HIGH_BOUND 13
#define READ_STATUS 14
#define RESET_MOUSE 15

#define XY_CHANGED 0x20
#define BUTTON_DOWN 0x80
#define BUTTON_WAS_DOWN 0x40

PS2Mouse mouse(PS2_DATA, PS2_CLK);
static byte mstat = 0;
static int mx = 0;
static int my = 0;
static int mx_high_boundary = 0x3ff;
static int mx_low_boundary = 0;
static int my_high_boundary = 0x3ff;
static int my_low_boundary = 0;
static bool xy_changed = true;
static bool button_down = false;
static bool button_was_down = false;

void setup() 
{
  pinMode(IRQ, OUTPUT);
  digitalWrite(IRQ, HIGH);
  pinMode(RW, INPUT);
  pinMode(CB2, INPUT);
  pinMode(ADD0, INPUT);
  pinMode(ADD1, INPUT);
  pinMode(ADD2, INPUT);
  pinMode(RW, INPUT);
  pinMode(PS2_CLK, OUTPUT);
  pinMode(PS2_DATA, INPUT);

  setInput();
  attachInterrupt(digitalPinToInterrupt(CB2), deviceSelect, FALLING);

  Serial.begin(19200);
  Serial.println("Hello");
  Serial.println();
  mouse.init();
}

void loop() 
{
  /* get a reading from the mouse */
  mouse.write(0xeb);  /* give me data! */
  mouse.read();      /* ignore ack */
  mstat = mouse.read();
  mx += mouse.read();
  my -= mouse.read();

  if(mstat & 0x01)
  {
    button_down = true;
  }
  else
  {
    button_down = false;
  }

  if(mx > mx_high_boundary)
    mx = mx_high_boundary;
  else if(mx< mx_low_boundary)
    mx = mx_low_boundary;

  if(my > my_high_boundary)
    my = my_high_boundary;
  else if(my < my_low_boundary)
    my = my_low_boundary;

}

void deviceSelect()
{
  static bool first_access = true;
  static unsigned int data;
  
  digitalWrite(LED, HIGH);
  byte address = getAddress();
  Serial.println(address, HEX);

  if(address == SET_INPUT)
  {
    setInput();
  }
  else if(address < SET_INPUT)
  {
    if(first_access)
    {
      if(address != WRITE_MODE)
      {
        first_access = false;
      }
      data = readByte();
    }
    else
    {
      first_access = true;
      data |= (readByte() << 8);
    }
  }

  if(first_access)
  {
    switch(address)
    {
      case WRITE_X:
        mx = data;
        break;
      case WRITE_Y:
        my = data;
        break;
  
      case READ_X:
        data = mx;
        break;
      case READ_Y:
        data = my;
        break;
      case READ_X_LOW_BOUND:
        data = mx_low_boundary;
        break;
      case READ_X_HIGH_BOUND:
        data = mx_high_boundary;
        break;
      case READ_Y_LOW_BOUND:
        data = my_low_boundary;
        break;
      case READ_Y_HIGH_BOUND:
        data = my_high_boundary;
        break;
      case READ_STATUS:
        data = mstat;
        break;
    }
  }

  
  if(address > SET_INPUT)
  {
    setOutput();

    if(first_access)
    {
      if(address != READ_STATUS)
      {
        first_access = false;
      }
      writeByte((byte)data);
    }
    else
    {
      first_access = true;
      writeByte((byte)(data >> 8));
    }
  }
  

  digitalWrite(LED, LOW);
}

void setOutput()
{
  DDRB |= 0x0f;
  DDRD |= 0xf0;
}

void setInput()
{
  DDRB &= ~0x0f;
  DDRD &= ~0xf0;
}

byte getAddress()
{
  return PINC & 0x0f;
}

byte readByte()
{
  byte data = PINB & 0x0f;
  data |= PIND & 0xf0;

  return data;
}

void writeByte(byte data)
{
  PORTB = (PORTB & 0xf0) | (data & 0x0f);
  PORTD = (PORTD & 0x0f) | (data & 0xf0);
}

