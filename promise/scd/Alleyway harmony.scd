(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["binSelect", "parseRt", "dnaStrand", "getInterleaved", "morseToDur"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)

(
// GET GIRL
~girl_a = ~dnaStrand.value(scale: Scale.minorPentatonic, root: 65, chord_size: 2, chord_interval: 10);
~girl_b = ~dnaStrand.value(scale: Scale.minorPentatonic, root: 60, chord_size: 4, chord_interval: 4);
// this harmony is quite beautiful ... and could work ... for when it comes to a head ... and they are at the moment of the actual Promise ... it spins and spins ... slowing.

// Is there a way to continuously update these values to feed the playback?? So then I could cycle through tonalities with a physical control?

// Need to think about rhythm ... how will it be controlled in the scene? And is this a good time to do the crossfade thing? Tendency masks?

// I think it would be nice to incorporate the clashes of polytonality using pentatonic scales here ... but in a more fluid way ... so it tends towards coming together and something bright and harmonious ...

~girl_a = ~girl_a.collect({
	arg chord, count;
	~binSelect.value("GREY", ~girl_a, offset: count, mode: "morse");
}).flatten;

~girl_b = ~girl_b.collect({
	arg chord, count;
	~binSelect.value("GREY", ~girl_b, offset: count, mode: "morse")
}).flatten;

~girl = ~getInterleaved.value(~girl_a, ~girl_b);
~girl.size;
)

// I'd quite like to do that thing I did previously with it reproducing itself??

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
		\midinote, Pseq(~girl, 1),
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
		\midinote, Pseq(~girl, 1),
		\legato, 1,
		\amp, 0.6,
		\dur, 1,
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

I want to set it up so that GIRL and WOMAN each have harmony that tends towards each other ... so that ultimately it ends up here. It starts dissonant, and gradually they close on each other.

So I need to find a way for the harmony to gradually spin closer to the harmony given here, with GIRL tending towards WOMAN ... she is changing but WOMAN stays the same.

Then I would like for the harmonies to be given as bludgeoning chords ... the feel of a fight. And I will also include the sound of industry and the city ... and metal and chaos.

Need also to factor in the different tunings, which I need to build ...

