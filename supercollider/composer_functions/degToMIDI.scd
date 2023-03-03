/*-------------------------------------------*/
/*===============IMPORTS=====================*/
/*-------------------------------------------*/
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["sequenceRoots", "getOctave"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
});

// returns a MIDI value given a degree, root and scale
~degToMIDI = {
	arg degree=4, root_midi=60, scale=Scale.major;
	var midivalue;
	// get number of semitones from degrees list, add to root value, and add (12 * octave level)
	midivalue = scale.degrees[degree % scale.size] + root_midi + (~getOctave.value(degree, scale.size) * 12);
	midivalue;
}


