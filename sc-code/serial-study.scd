// Run this line to check the serial port devices
SerialPort.listDevices;

// Run this line to reset the serial port connection
SerialPort.closeAll;

(
// Define and open the serial port
// Change the port argument
~port = SerialPort("COM7", baudrate: 9600);


// Function to convert array into formated string
f = { |arr|
	var outputStr;
	arr.do { |i, idx|
		outputStr = outputStr ++ i.asString;
	};
	// Return the concatenated string
	outputStr;
};


// Create a pattern as stream data
// Use Brownian walk pattern with a step of 1 within interval [0, 23]
p = Pbrown(0, 23, 1).asStream;


// Routine loop.
// If it is playing, it sends message to serial port every one second
Routine({
	// Infinite loop to update the value of the brownian walk
	inf.do({
		var a_, b_, c_, msg;

		// Array to be written of size 8, initialized with zero values
		a = Array.fill(8, { arg i; 0 });
		b = Array.fill(8, { arg i; 0 });
		c = Array.fill(8, { arg i; 0 });

		// Call the next value of the brownian stream
		v = p.next.postln;

		// Update the array value accordingly
		case
		{ (v<8)            } { a[v] = 1     }
		{ (v>=8) && (v<16) } { b[(v%8)] = 1 }
		{ (v>=16)          } { c[(v%8)] = 1 };

		// Convert the array into strings
		a_ = f.value(a);
		b_ = f.value(b);
		c_ = f.value(c);

		// Concatenate all strings
		msg = "<" ++ a_ ++ "," ++ b_ ++ "," ++ c_ ++ ">";

		// BENN added the following line for testing
		//msg = "<00001000,00000000,00000000>";
		msg.postln;

		// Send message to serial port
		~port.putAll(msg);

		// 1 second interval
		0.100.wait;
	});
}).play;
)

