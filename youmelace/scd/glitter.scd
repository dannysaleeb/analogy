// GLITTER TEXTURE

(
// Testing getting glitter texture only when no chord onset
var returnlist, counter = 0;

~me.do({
	arg item;
	if(
		item.isKindOf(SequenceableCollection) == true,
		{
			2.do({
				returnlist = returnlist.add(0);
				counter = counter + 1
			});
			4.do({
				returnlist = returnlist.add(~realnotes[counter % ~realnotes.size]);
				counter = counter + 1
			})
		},
		{
			6.do({
				returnlist = returnlist.add(~realnotes[counter % ~realnotes.size]);
				counter = counter + 1
			})
		}
	)
});

~finally = returnlist;
)

// Get 24 notes from the given list, with probability as given by list.
24.collect({[67, 65, 69].wchoose([0.6, 0.3, 0.1])});

// Get some number of chunks from the given list
~chunks = {
	arg list, num, chunkmin, chunkmax;
	var returnlist, chunk_size;
	num.do({
		arg i;
		chunk_size = chunkmax.rrand(chunkmin);
		returnlist = returnlist.add(
			chunk_size.collect({
				arg j;
				list[i+j % list.size]
			})
		)
	});
	returnlist
}

// e.g.
~chunks.value(~notes, 30, 2, 4);


~notes = 24.collect({[67, 69].wchoose([0.9, 0.1])});

~realnotes = ~notes.collect({
	arg note;
	note + [-12, 12, 24].wchoose([0.7, 0.2, 0.1])
});

~glitter_a = ~realnotes.morseselect("thisisme", oneMultiplier: 5, zeroMultiplier: 2, zeroReplace: 0);
~glitter_b = ~realnotes.morseselect("thisisme", offset: 2, oneMultiplier: 4, zeroMultiplier: 2, zeroReplace: 0);

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
// PIANO 1
Pdef(
	\glitter_a,
	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 3,
		\midicmd, \noteOn,
		\midinote, Pseq(~glitter_a, inf),
		\legato, 1,
		\amp, 0.6,
		\dur, Pseq("amherei".morse2dur(0.125), inf);
	);
).play(quant: 2);

// PIANO 2
Pdef(
	\glitter_b,
	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 2,
		\midicmd, \noteOn,
		\midinote, Pseq(~glitter_b, inf),
		\legato, 1,
		\amp, 0.6,
		\dur, Pseq("amherei".morse2dur(0.125), inf);
	);
).play(quant: 2);
)

(
Routine.new({

	r = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~realnotes, inf),
		\legato, 1,
		\amp, 0.05,
		\dur, Pseq("amherei".morse2dur(1/12, 1/6), inf);
	).play(quant: 2);

	r = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 3,
		\midicmd, \noteOn,
		\midinote, Pseq([67], inf),
		\legato, 1,
		\amp, 0.05,
		\dur, Pseq("amherei".morse2dur(0.125), inf);
	).play(quant: 2);


}).play;
)