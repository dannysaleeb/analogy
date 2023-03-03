(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["sequenceRoots", "getMin", "getMax", "compare", "getSimVal", "sequenceChords", "degToMIDI", "getOctave", "invertChord"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)


/*-------------------------------------------*/
/*=================SKETCH====================*/
/*-------------------------------------------*/


// Modulating sequence of chords ...

// PARENT 1:
(
var roots = ~sequenceRoots.value([-3,1,1]), parent, chords1, chords2;
parent = ~sequenceChords.value(roots);



chords1 = 12.collect({
	arg num;
	parent.collect({
		arg chord;
		chord.collect({
			arg degree;
			~degToMIDI.value(degree, root_midi: 60 + (7 * num), scale: Scale.major)
		});
	});
});

chords2 = 12.collect({
	arg num;
	parent.collect({
		arg chord;
		chord.collect({
			arg degree;
			~degToMIDI.value(degree, root_midi: 60 + (7 * num), scale: Scale.egyptian)
		});
	});
});

h = chords1.flatten;
k = chords2.flatten;
)

// PARENT 2
(
var roots = ~sequenceRoots.value([-3, 4]), parent, chords1, chords2;

parent = ~sequenceChords.value(roots, 2, 4);

chords1 = 12.collect({
	arg num;
	parent.collect({
		arg chord;
		chord.collect({
			arg degree;
			~degToMIDI.value(degree, root_midi: 67 + (7 * num), scale: Scale.scottish)
		});
	});
});

chords2 = 12.collect({
	arg num;
	parent.collect({
		arg chord;
		chord.collect({
			arg degree;
			~degToMIDI.value(degree, root_midi: 60 + (7 * num), scale: Scale.scottish)
		});
	});
});

l = chords1.flatten;
n = chords2.flatten;
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
p = Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq(l, inf),
	\legato, 1,
	\dur, 0.25
).play;
)