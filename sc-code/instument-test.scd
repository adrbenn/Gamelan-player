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

		// INST 1

		msg = "<10000000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<01000000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00100000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00010000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00001000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000100,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000010,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000001,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		// INST 2

		msg = "<00000000,10000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,01000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00100000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00010000,00000000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00001000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000100,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000010,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000001,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		// INST 3

		msg = "<00000000,00000000,10000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,01000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,00100000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00010000,00000000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,00001000>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,00000100>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,00000010>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;

		msg = "<00000000,00000000,00000001>";
		msg.postln;	~port.putAll(msg);
		0.500.wait;


	});
}).play;
)

