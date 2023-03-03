(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["morseWordToBinary", "asciiToBinary", "dnaStrand", "getOrganism", "binSelect", "constrainSeq"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)

(
Scale.all.put(\scottish, Scale([0,2,5,7,9]));
)

/*(
~you_a = ~dnaStrand.value(scale: Scale.scottish, root: 58);
~you_b = ~dnaStrand.value(scale: Scale.scottish, root: 67);
~you = ~getInterleaved.value(~you_a, ~you_b);

~kitty = ~binSelect.value("kitty", ~you, mode: "morse");
)*/

(
// GET YOU
~you_a = ~dnaStrand.value(pattern: [-1, 3], scale: Scale.scottish, root: 63, chord_size: 2, chord_interval: 5);
~you_b = ~dnaStrand.value(pattern: [-4, 3], scale: Scale.scottish, root: 58, chord_size: 2, chord_interval: 6);

~you_a = ~you_a.collect({
	arg chord, count;
	~binSelect.value("kitty", ~you_a, offset: count, mode: "morse");
}).flatten;

~you_b = ~you_b.collect({
	arg chord, count;
	~binSelect.value("kitty", ~you_b, offset: count, mode: "morse")
}).flatten;

~you = ~getInterleaved.value(~you_a, ~you_b);
~you.size;
)

z = ~constrainChords1.value(80, 120, ~you);
z = z.collect({
	arg item;
	if(item.size == 0, { 0 }, { item })
});

~youmeTest = ~getInterleaved.value(z, ~me);
~me.size;
z.size;

~getInterleaved;

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
	\midinote, Pseq(~youmeTest, inf),
	\amp, 0.5,
	\legato, 2,
	\dur, 1
).trace.play;
)

p.stop;

// Across the two pianos ... top morse and bottom morse split across the pnos

(
~dannyPlay = Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, 67+12,
	\amp, 0.2,
	\legato, 0.5,
	\dur, Pseq(~morseToDur.value("danny", 0.125), inf)
).trace.play;

~kittyPlay = Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 1,
	\midicmd, \noteOn,
	\midinote, 67-12,
	\amp, 0.2,
	\legato, 0.5,
	\dur, Pseq(~morseToDur.value("kitty", 0.125), inf)
).trace.play;
)

~dannyPlay.play;
~kittyPlay.play;

s.boot;

// Messing with SynthDefs might be fun for creating music to upload ...
SynthDef.new(
	\mySynth,
	{
		arg out, freq;
		Out.ar(
			out,
			SinOsc.ar(freq, 0, 0.2) * Line.kr(1, 0, 1, doneAction: Done.freeSelf)
		)
}).add;

Routine.new(
	{
		~youmeTest.do({
			arg item;
			item.do({
				arg note;
				Synth(\mySynth, [\out, [0, 1], \freq, note.midicps]);
			});
			1.wait;
		})
	}
).play

// this is ridiculously massive ... 11.5 days long ... (at this speed...)
// it is 1400 chords * 1288 chords ...
~youmeTest.size;

// checking phase ... [1,2,3,4] [1,2] --> [1,1,2,2,3,1,4,2]
// [1, 2, 3, 4, 5] [6, 7, 8] --> [1,6,2,7,3,8,4,6,5,7,1,8,2,6,3,7,4,8,5,6,1,7,2,8,3,6,4,7,5,8]

// [123, 451, 234, 512, 345]

// (size1 * size2) * number of items ...(when interleaved ...)

(
// [you, me].lace
Routine({
	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~you, inf),
		\amp, 0.4,
		\legato, 2,
		\dur, 1
	).trace.play;

	0.5.wait;

	p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(~me, inf),
		\amp, 0.4,
		\legato, 2,
		\dur, 1
	).trace.play;

	0.5.wait

}).play;
)