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

// PARENT 1:
(
var roots = ~sequenceRoots.value([-3,1,1]), parent, chords1, chords2;
parent = ~sequenceChords.value(roots);

chords1 = parent.collect({
	arg chord;
	chord.collect({
		arg degree;
		~degToMIDI.value(degree, scale: Scale.major);
	});
});

chords2 = parent.collect({
	arg chord;
	chord.collect({
		arg degree;
		~degToMIDI.value(degree, scale: Scale.egyptian);
	});
});

a = chords1.collect({
	arg chord;
	~invertChord.value(chord, Scale.major.degrees.size, 3.rand);
});
b = chords2.collect({
	arg chord;
	~invertChord.value(chord, Scale.egyptian.degrees.size, 3.rand);
});
)

// PARENT 2
(
var roots = ~sequenceRoots.value([-3, 4]), parent, chords1, chords2;

parent = ~sequenceChords.value(roots, 2, 4);

chords1 = parent.collect({
	arg chord;
	chord.collect({
		arg degree;
		~degToMIDI.value(degree, root_midi: 67, scale: Scale.scottish);
	})
});

chords2 = parent.collect({
	arg chord;
	chord.collect({
		arg degree;
		~degToMIDI.value(degree, scale: Scale.scottish);
	})
});

c = chords1;
d = chords2;
)

/*-------------------------------------------*/
/*==================SAVES====================*/
/*-------------------------------------------*/
(
f = File.new((~path ++ "output/siblings_saves.txt"), "a");

f.write("DS a:\n\n");
a.do({
	arg chord;
	f.write(chord.asString);
});
f.write("\n\n");

f.write("DS b:\n\n");
b.do({
	arg chord;
	f.write(chord.asString);
});
f.write("\n\n");

f.write("KH a:\n\n");
c.do({
	arg chord;
	f.write(chord.asString);
});
f.write("\n\n");

f.write("KH b:\n\n");
d.do({
	arg chord;
	f.write(chord.asString);
});
f.write("\n\n");

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
// PARENT 1
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(a, inf),
		\legato, 1,
		\dur, 1
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(b, inf),
		\legato, 1,
		\dur, 1
	).play;
}).play;
)

c;

(
// PARENT 2
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(c, inf),
		\legato, 1,
		\dur, 1
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(d, inf),
		\legato, 1,
		\dur, 1
	).play;
}).play
)

(
// COMBINE 1
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq([a,b].lace, inf),
		\legato, 1,
		\dur, 1
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq([c,d].lace, inf),
		\legato, 1,
		\dur, 1
	).play;
}).play
)


(
// COMBINE 2
Routine({
	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(a, inf),
		\legato, 1,
		\dur, 2
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(b, inf),
		\legato, 1,
		\dur, 2
	).play;

	0.5.wait;

	// Voice 1
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 2,
		\midicmd, \noteOn,
		\midinote, Pseq(c, inf),
		\legato, 1,
		\dur, 2
	).play;

	0.5.wait;

	// Voice 2
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 3,
		\midicmd, \noteOn,
		\midinote, Pseq(d, inf),
		\legato, 1,
		\dur, 2
	).play;

	0.5.wait
}).play
)