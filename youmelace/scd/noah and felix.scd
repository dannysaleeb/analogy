(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["sequenceRoots", "getMin", "getMax", "compare", "getSimVal", "sequenceChords", "degToMIDI", "getOctave", "invertChord", "morseWordToBinary"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)

/*-------------------------------------------*/
/*=================SKETCH====================*/
/*-------------------------------------------*/

// child 1
~child1_morse = ~morseWordToBinary.value("noah");
~child1_morse = ~child1_morse.add([0,0]).flatten;

// child 2
~child2_morse = ~morseWordToBinary.value("felix");
~child2_morse = ~child2_morse.add([0,0]).flatten;


// Define children using morse
// 1 starts on odds, other starts on evens

~youmeTest.size;
(
~child1 = [];
~youmeTest.size.do({
	arg num;
	~child1_morse.do({
		arg bit, count;
		if(
			bit == 1,
			{ ~child1 = ~child1.add(~youmeTest[count + (num*2) % ~youmeTest.size]) }
		);
	});
});

~child2 = [];
~youmeTest.size.do({
	arg num;
	~child2_morse.do({
		arg bit, count;
		if(
			bit == 1,
			{ ~child2 = ~child2.add(~youmeTest[(count + 1 + (num*2)) % ~youmeTest.size]) }
		)
	})
})
)

~child1;

// Now convert morse to binary?? if dah, add [1,1,1,0], if dit add [1,0]

/*-------------------------------------------*/
/*==================SAVES====================*/
/*-------------------------------------------*/
(
f = File.new((~path ++ ""), "a");

/*f.write("DS a:\n\n");
a.do({
	arg chord;
	f.write(chord.asString);
});
f.write("\n\n");*/

f.close;
)

/*-------------------------------------------*/
/*================PLAYBACK===================*/
/*-------------------------------------------*/

(
// MIDI setup
MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);
)

// record me, you, youme, child1, child2
~child2.size;
(
// Child 1 & 2
Routine({
	// Child 1
	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~child1, 1),
		\legato, 2,
		\dur, 0.5
	).play;

	// Child 2
	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(~child2, 1),
		\legato, 2,
		\dur, 0.5
	).play;

}).play;
)