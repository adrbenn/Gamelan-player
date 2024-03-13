// Run this line to check the serial port devices
SerialPort.listDevices;

// Run this line to reset the serial port connection
SerialPort.closeAll;

(
// Define and open the serial port
// Change the port argument
~port = SerialPort("COM7", baudrate: 9600);


// Routine loop.
Routine({
	inf.do({
		var msg;

		// SINGLES

		msg = "<10000000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<01000000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00100000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00010000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00001000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00000100,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00000010,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00000001,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		// DOUBLES

		msg = "<11000000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00110000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00001100,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00000011,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		// TRIPLES + QUADS

		msg = "<11100000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00011100,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<11100010,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;

		msg = "<00011101,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);
		0.500.wait;
	});
}).play;
)

