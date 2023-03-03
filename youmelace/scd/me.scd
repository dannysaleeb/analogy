(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["binSelect", "parseRt", "dnaStrand", "getOrganism", "morseToDur"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)

(
// GET ME
~me_a = ~dnaStrand.value(scale: Scale.major, chord_size: 2, chord_interval: 10);
~me_b = ~dnaStrand.value(scale: Scale.minorPentatonic, chord_size: 4, chord_interval: 4);

~me_a = ~me_a.collect({
	arg chord, count;
	~binSelect.value("Danny", ~me_a, offset: count, mode: "morse");
}).flatten;

~me_b = ~me_b.collect({
	arg chord, count;
	~binSelect.value("Danny", ~me_b, offset: count, mode: "morse")
}).flatten;

~me = ~getInterleaved.value(~me_a, ~me_b);
~me.size;
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
Routine.new({
	a = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~me, 1),
		\legato, 1,
		\amp, 0.6,
		\dur, 1,
	).trace.play(quant: 2);

	8.wait;

	b = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(~me, 1),
		\legato, 1,
		\amp, 0.6,
		\dur, 2/3,
	).trace.play(quant: 2);

}).play
)

(
a.pause;
b.pause;
)

(
a.play;
b.play;
)