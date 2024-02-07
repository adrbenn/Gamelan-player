// Run this line to check the serial port devices
SerialPort.listDevices;

(
// Define and open the serial port
// Change the port argument
//~port = SerialPort("port/To/Be/Opened", baudrate: 9600);


// Function to convert array into formated string
f = { |arr|
	var outputStr;
	arr.do { |i, idx|
		if (idx==0) {
			outputStr = i.asString;
		} {
			outputStr = outputStr ++ i.asString;
		};
	};
	// Return the concatenated string
	outputStr;
};


// Use cellular automata for an array size of 24
// Require additional library from https://github.com/yotamorimoto/sc_ca

// Create initial array
x = Array.fill(24, { |i|
	if (i==4){ 1 }{ 0 };
});

// Create the pattern as stream data with CA rule 110
p = Pca1(x, 110, inf).asStream;


// Routine loop.
// If it is playing, it sends message to serial port every time interval

Routine({
	// Infinite loop to update the value of the brownian walk
	inf.do({
		var a_, b_, c_, msg;

		// Call the next value of the CA stream
		v = p.next;

		// Spread the array into three
		a = v[0..7];
		b = v[8..15];
		c = v[16..23];

		// Convert the array into strings
		a_ = f.value(a);
		b_ = f.value(b);
		c_ = f.value(c);

		// Concatenate all strings
		msg = "<" ++ a_ ++ "," ++ b_ ++ "," ++ c_ ++ ">";
		("Message: " ++ msg).postln;

		// Send message to serial port
		//~port.putAll(msg);

		// Interval duration using exponential distribution between [0.5, 2] seconds
		t = 0.5.exprand(2);
		("Duration: " ++ t).postln;
		"".postln;
		t.wait;
	});
}).play;
)