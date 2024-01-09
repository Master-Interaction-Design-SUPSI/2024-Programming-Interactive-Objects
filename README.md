# One Thousand~ Pixels
SUPSI MAInD  
Programming interctive objects  
Workshop 5–9.1.2024

# Project Brief
The aim of the workshop is to embrace constratints and develop ideas around the limitations of a low resolution display. 

# Topics
- Idea driven development and research 
- Realtime graphics and animation concepts 
- Serial communication 
- Quick prototyping 
- LED matrices 

# Part list
- RGB LED matrix 32×32 P6 (P6 means that the LED pitch is 6mm)
- PicoDriver, custom ESP32 controller
- USB-C cable (data and power)
- 5V power cable for the LED matrix (usually comes with the matrix)

Aleternative to the custom PicoDriver:  
- [Teensy 4.0 or 4.1 development board](https://www.pjrc.com/teensy/) (a Teensy 3.2 will do but has limited memory and processor speed)
- [SmartLed shield](https://docs.pixelmatix.com/SmartMatrix/) (not strictly necessary but handy to quickly connect the microcontroller)
- Micro-USB cable for Teensy programming
- 5V power supply (3A minimum), plus cables

# Software requirements
- [VS Code](https://code.visualstudio.com/download)
- [Platformio for VS Code](https://platformio.org) (install as VS Code plugin)
- [Processing IDE](https://www.processing.org/download/) (or any framework able to send data to the serial port)
- [GitHub Desktop](https://desktop.github.com) (not mandatory, but handy)
- Some Windows machines may need an extra serial port driver [CP210x USB to UART Bridge](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers?tab=downloads)  

# Workshop organization

### Day 1  
- “1024 pixels“ assignment and start of the week  
- Introduction to LED matrices  
- Introduction to the ESP32 microcontroller
- Software setup (VS Code, GitHub, etc.)
- Introdcution/recap to Arduino 
- Introdcution/recap to Processing
- Introduction to serial ports and serial communication
- Introduction to realtime graphics and graphics APIs

### Day 2-4
- Code exercises, theory
- Personal reserach, prototyping, project development 
- Daily feedback and project discussion  

### Day 5
- Presentation 
- Documentation 

# Prepare for the daily project critique
- Try a direction with focus on each of these approaches:  
the phyiscial LED matrix, LEDs as light source(s), context
- Bring something interesting, a little discovery – not an idea for a finished project; let the process guide you
- Show hand drawings and sketches, low-quality screenshots or videos, a little demo, an animation  
- No mood-boards! No projects of others that involve LED matrices! 

### Fallback 
- If you are unable to generate an idea turn the matrix into a (new) clock!
