// Gets root position chords for a list of chord roots
~sequenceChords = {
	arg roots, size=3, interval=3;
	roots.collect({
		arg root;
		size.collect({
			arg num;
			root + ((interval - 1) * num);
		})
		// here add rotation depending on inversion value
	})
};

// TESTS
/*e = ~sequenceChords.value((0..7), 4, 5);
g = e.collect({
	arg chord;
	chord.collect({
		arg degree;
		~degToMIDI.value(degree, scale: Scale.major);
	});
});

p = Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq(g, inf),
	\legato, 1,
	\dur, 1
).play;*/