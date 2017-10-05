
#ifndef PS2Mouse_h

#define PS2Mouse_h

class PS2Mouse
{
  private:
    int _clock_pin;
    int _data_pin;
    void gohi(int pin);
    void golo(int pin);
  public:
    PS2Mouse(int data_pin, int clock_pin);
    void write(char data);
    char read(void);
    void init(void);
};

#endif

