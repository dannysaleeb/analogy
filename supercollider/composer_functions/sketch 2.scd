(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["sequenceRoots", "getMin", "getMax", "compare", "getSimVal", "sequenceChords", "degToMIDI", "getOctave", "invertChord", "textToBinary"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
})
)

/*-------------------------------------------*/
/*=================SKETCH====================*/
/*-------------------------------------------*/


a;
b;
c;
d;

// Now start to pick out chords based on these sequences, using binary data from names

//
// modulating
//
(
var parent1, parent2, combined, parent1_bin, parent2_bin, combined_bin, parent1_select = [], parent2_select = [];

// Define parent names
parent1 = "Danny".asList;
parent2 = "Kitty".asList;

// Define parents combined text
combined = [parent1, parent2].lace;

// Get binary data for each
parent1_bin = ~textToBinary.value(parent1).flatten;
parent2_bin = ~textToBinary.value(parent2).flatten;
combined_bin = ~textToBinary.value(combined).flatten;

// Create sequence of chords based on binary data for each ...
[h,k].lace.size.do({
	arg num;
	if(
		parent1_bin[num % parent1_bin.size] == 1,
		{ parent1_select = parent1_select.add([h,k].lace[num]) }
	);
});

[n,l].lace.size.do({
	arg num;
	if(
		parent2_bin[num % parent2_bin.size] == 1,
		{ parent2_select = parent2_select.add([n,l].lace[num]) }
	);
});

z = parent1_select;
y = parent2_select;
)

//
// non-modulating
//
(
var parent1, parent2, combined, parent1_bin, parent2_bin, combined_bin, parent1_select = [], parent2_select = [];

// Define parent names
parent1 = "Danny".asList;
parent2 = "Kitty".asList;

// Define parents combined text
combined = [parent1, parent2].lace;

// Get binary data for each
parent1_bin = ~textToBinary.value(parent1).flatten;
parent2_bin = ~textToBinary.value(parent2).flatten;
combined_bin = ~textToBinary.value(combined).flatten;
parent1_bin.do({
	arg bin, count;
	if(
		bin == 1,
		{ parent1_select = parent1_select.add([h,k].lace[count % [h,k].lace.size]) }
	);
});

parent2_bin.do({
	arg bin, count;
	if(
		bin == 1,
		{ parent2_select = parent2_select.add([l,n].lace[count % [l,n].lace.size]) }
	);
});

z = parent1_select;
y = parent2_select;
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
//
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(z, inf),
		\amp, Pseq([0.1, 0.3, 0.2, 0.5], inf),
		\legato, Pseq([0.5, 2, 1, 4], inf),
		\dur, 1
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(y, inf),
		\amp, Pseq([0.1, 0.3, 0.2, 0.5].mirror, inf),
		\legato, Pseq([0.5, 2, 1, 4].mirror, inf),
		\dur, 1
	).play;

	0.5.wait

}).play;
)
