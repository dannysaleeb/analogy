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

// Noah
~noah_morse = ~morseWordToBinary.value("noah");
~noah_morse = ~noah_morse.add([0,0]).flatten;

// Felix
~felix_morse = ~morseWordToBinary.value("felix");
~felix_morse = ~felix_morse.add([0,0]).flatten;


// Define Noah using morse
(
~noah = [];
~noah_morse.do({
	arg bit, count;
	if(
		bit == 1,
		{ ~noah = ~noah.add([~you, ~me].lace[count+2]) },
		{ ~noah = ~noah.add(Rest(0.5))}
	)
})
)

// Define Felix using morse
(
~felix = [];
~felix_morse.do({
	arg bit, count;
	if(
		bit == 1,
		{ ~felix = ~felix.add([~you, ~me].lace[count+1]) },
		{ ~felix = ~felix.add(Rest(0.5))}
	)
})
)

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

(
// ME
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~noah, 1),
		\legato, 2,
		\dur, 0.5
	).play;
}).play;
)