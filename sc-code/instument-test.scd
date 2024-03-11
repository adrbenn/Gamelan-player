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

		msg = "<10000000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.250.wait;

		/*msg = "<01000000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;

		msg = "<00100000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;

		msg = "<00010000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;

		msg = "<00001000,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;

		msg = "<00000100,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;

		msg = "<00000010,00000000,00000000>";
		msg.postln;
		~port.putAll(msg);

		// interval
		0.500.wait;*/

		//msg = "<00000001,00000000,00000000>";
		//msg.postln;
		//~port.putAll(msg);

		// interval
		//0.200.wait;
	});
}).play;
)

