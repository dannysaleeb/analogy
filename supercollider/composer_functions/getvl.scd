(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["invertMIDIChord", "getSimVal", "getListMin"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
})
);

// Compares two chords thos and thot, rotating thot as many times as dictated by the range argument (a list of consecutive ints, negative --> positive), and returns the chord that has the most similar position.
~getvl = {
	arg thos, thot, range=(-3..3);
	var chords, simVals, index;
	// get list of rotated chords in range
	chords = range.collect({
		arg num;
		~invertMIDIChord.value(thot, num)
	});
	chords.postln;
	simVals = chords.collect({
		arg chord;
		~getSimVal.value(thos, chord)
	});
	simVals.postln;
	chords[~getIndex.value(simVals, ~getListMin.value(simVals)).postln]

};

~vl = ~getvl.value([52, 64, 78], [41, 76, 104], range: (-6..6));

// for each chord, get the next best chord ...
~sequencevl = {
	arg midi_sequence, range=(-3..3);
	var returnlist, next;
	midi_sequence
}

// create a graph for each chord ... each chord tone has edge with every other chord tone... so: for each chord_tone, write a list of edges, including with self...

~getChordGraph = {
	arg midi;
	var chord=[];
	midi.collect({
		arg midi_value_i, count;
		midi.collect({
			arg midi_value_j, count;
			var edge_value = midi_value_j - midi_value_i;
			if( edge_value.isNegative, { edge_value.neg }, { edge_value } )
		})
	})
}

~chord1 = [67, 72, 76];
~chord2 = [67, 71, 74];

a = ~getChordGraph.value(~chord1);
b = ~getChordGraph.value(~chord2);

~getIntervalsFromGraph = {
	arg chord_graph;
	var returnlist;
	chord_graph.collect({
		arg chord
	})
}

~createChordDict = {
	arg midi_chord;
	var dict = Dictionary();

	midi_chord.do({
		arg midival, count;
		dict.put(count.asSymbol, midival)
	});
	dict
}

~testChordDict = ~createChordDict.value([67,72,76]);

c = a - b;

(
// MIDI setup
MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);
)

(
Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq([[52, 64, 78], ~vl], inf),
	\legato, 1,
	\dur, 1
).play;
)