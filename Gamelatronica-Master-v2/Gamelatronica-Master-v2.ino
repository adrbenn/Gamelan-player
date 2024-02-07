// *************************************************************************************
// MASTER
// Program for the Gamelan player project in Berlin, March 2024
// - Adrian Benn
//
// The Arduino codes for the project are modified from these two sources:
// 1. L293D motor driver shield program to control the solenoids
//    Author:         John Miller
//    Revision:       1.1.0
//    Date:           8/4/2018
//    Project Source: https://github.com/jpsrmiller/l293d-master-slave
//    See https://buildmusic.net/tutorials/motor-driver/ for a wiring schematic
//
//    More details about L293D:
//    https://lastminuteengineers.com/l293d-motor-driver-shield-arduino-tutorial/ 
//
// 2. Serial communication program to receive signals from Super Collider
//    Source: https://forum.arduino.cc/t/serial-input-basics-updated/382007/3
//
// *************************************************************************************



//============
// The following part is for L293D master-slave control
//============

#include <Arduino.h>
#include <SoftwareSerial.h>

// Define the IO Pins Used
#define PIN_SW_SERIAL_RX  A0   // Software Serial Recieve pin
#define PIN_SW_SERIAL_TX	A1   // Software Serial Transmit pin

// Define the total number of Slave Arduino's with Motor Shields connected
#define MOTOR_SHIELD_COUNT	3

SoftwareSerial swSerial(PIN_SW_SERIAL_RX, PIN_SW_SERIAL_TX);

//============
// The following part is for parsing serial communication from Super Collider
//
// Message format: <00000000,00000000,00000000>
//                   inst. 1, inst. 2, inst. 3
//============

const byte numChars = 32;
char receivedChars[numChars];
char tempChars[numChars];        // temporary array for use when parsing

// variables to hold the parsed data
char messageFromPC1[numChars] = {0};
char messageFromPC2[numChars] = {0};
char messageFromPC3[numChars] = {0};

boolean newData = false;

//============

void setup() {
    swSerial.begin(57600);
    Serial.begin(9600);
    Serial.println("Ready");
}

//============

void loop() {
    recvWithStartEndMarkers();
    if (newData == true) {
        strcpy(tempChars, receivedChars);
            // this temporary copy is necessary to protect the original data
            // because strtok() used in parseData() replaces the commas with \0
        parseData();
        showParsedData();
        // BENN: change this showParsedData to something else later!
        newData = false;
    }

    // Test
    //playNote(0, 0);
    //delay(1000);
}

//============
// Functions to deal with serial communication from Super Collider
//
// recvWithStartEndMarkers()  // receiving the serial comm
// parseData()                // split the data into its parts (for three instruments)
// showParsedData()           // display the received data
// -->> BENN: add a new function specific for forwarding the parsed data to L293D
//
//============


void recvWithStartEndMarkers() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;

    while (Serial.available() > 0 && newData == false) {
        rc = Serial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

//============

void parseData() {      // split the data into its parts

    char * strtokIndx; // this is used by strtok() as an index

    strtokIndx = strtok(tempChars,",");     // get the first part - the string
    strcpy(messageFromPC1, strtokIndx);     // copy it to messageFromPC

    strtokIndx = strtok(NULL, ",");         // this continues where the previous call left off
    strcpy(messageFromPC2, strtokIndx);

    strtokIndx = strtok(NULL, ",");
    strcpy(messageFromPC3, strtokIndx);
 
}

//============

void showParsedData() {
    Serial.print("Message1 ");
    Serial.println(messageFromPC1);
    Serial.print("Message2 ");
    Serial.println(messageFromPC2);
    Serial.print("Message3 ");
    Serial.println(messageFromPC3);

    // this works for playing 1 note at a time
    //playNote(0, atoi(messageFromPC1));

    // play multiple notes?
    int notes = 0;
    int ascii_trickery = 0; // idk why this is needed, but it is

    for(int i = 0; i < 8; i++){
      ascii_trickery = int(messageFromPC1[i] - '0');
      switch(i){
        case 0:
          notes = notes + ascii_trickery*128;
          break;
        case 1:
          notes = notes + ascii_trickery*64;
          break;
        case 2:
          notes = notes + ascii_trickery*32;
          break;
        case 3:
          notes = notes + ascii_trickery*16;
          break;
        case 4:
          notes = notes + ascii_trickery*8;
          break;
        case 5:
          notes = notes + ascii_trickery*4;
          break;
        case 6:
          notes = notes + ascii_trickery*2;
          break;
        case 7:
          notes = notes + ascii_trickery*1;
          break;
      }
    }
    Serial.println(notes);
    
    sendMotorShieldCommand(0, notes);
    delay(100);
    sendMotorShieldCommand(0, 0); // De-energize all channels
    delay(1000);
}


// ****************************************************************************
// Functions to deal with L293D master-slave communication
//
// playNote() - energize and de-energize a channel once 
// sendMotorShieldCommand() - Send a Serial Command to the Slave
//
// and some examples of how they are used
// 
// ****************************************************************************

// ****************************************************************************
// playNote() - energize and de-energize a channel once 
// ****************************************************************************
void playNote(uint8_t slaveAddr, uint8_t channelIndex)
{

	sendMotorShieldCommand(slaveAddr, 1 << channelIndex);
	delay(80);
	sendMotorShieldCommand(slaveAddr, 0);
	delay(500);
}

// ****************************************************************************
// sendMotorShieldCommand() - Send a Serial Command to the Slave
//       Serial Command is of the form: <aabb>
//       where aa is the Slave Address in Hexadecimal
//       and   bb is a Bitmask of the channels to be energized
// ****************************************************************************
void sendMotorShieldCommand(uint8_t boardNum, uint8_t pdata)
{
	swSerial.print(F("<"));
	if (boardNum < 0x10)
		swSerial.print(F("0"));
	swSerial.print(boardNum, HEX);
	if (pdata < 0x10)
		swSerial.print(F("0"));
	swSerial.print(pdata, HEX);
	swSerial.println(F(">"));
	return;
}

// ****************************************************************************
// EXAMPLES
// ****************************************************************************

// *********************************************************************************
// energizeSolenoidsInOrder() - Energize all solenoids sequentially 
// *********************************************************************************
void energizeSolenoidsInOrder()
{
	uint8_t i, j;
	for (i = 0; i<MOTOR_SHIELD_COUNT; i++)
	{
		for (j = 0; j<8; j++)
			playNote(i, j);
	}
}

// ****************************************************************************
// serialSyntaxExample() - Example of printing messages directly to Serial 
// ****************************************************************************
void serialSyntaxExample()
{
	// Energize Slave 0 Channels 0 and 1
	swSerial.print(F("<0003>"));
	delay(100);
	//De-energize All Channels
	swSerial.print(F("<0000>"));
	delay(1000);

	// Energize Slave 0 Channel 1, Slave 1 Channel 3, Slave 2 Channel 5 and Slave 3, Channel 7
	swSerial.print(F("<0002><0108><0220><0380>"));
	delay(100);
	//De-energize All Channels
	swSerial.print(F("<0000><0100><0200><0300>"));
	delay(1000);
}

// *********************************************************************************
// multiSlaveExample() - Example of energizing solenoids in multiple slaves at once 
// *********************************************************************************
void multiSlaveExample()
{
	// Energize Slave 0 Channels 0 and 1
	sendMotorShieldCommand(0, B00000011);
	// Energize Slave 1 Channels 3 and 4
	sendMotorShieldCommand(1, B00011000);
	// Energize Slave 2 Channels 5 and 7
	sendMotorShieldCommand(2, B10100000);
	delay(100);
	sendMotorShieldCommand(0, 0); // De-energize all channels
	sendMotorShieldCommand(1, 0); // De-energize all channels
	sendMotorShieldCommand(2, 0); // De-energize all channels
	delay(100);
}