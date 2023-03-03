/*-------------------------------------------*/
/*===============IMPORTS=====================*/
/*-------------------------------------------*/
(
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["dnaStrand"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
})
);
// interleaves two sequences or strands, producing a new sequence whose size is the product of the size of the two given sequences if they are different lengths.
~getInterleaved = {
	arg strand1, strand2;
	if(
		strand1.size != strand2.size,
		{ [strand1, strand2].lace(strand1.size * strand2.size) },
		{ [strand1, strand2].lace }
	);
}

// major scale with diad 10ths combined with minorPenta with tetrads intervals of 4 -- lovely sound

/*-------------------------------------------*/
/*=================TESTS=====================*/
/*-------------------------------------------*/
/*(
~strand_a = ~dnaStrand.value(pattern: [-1,3], scale: Scale.minorPentatonic, root: 62, chord_size: 2, chord_interval: 7);

~strand_b = ~dnaStrand.value(pattern: [-4, 3], scale: Scale.minorPentatonic, root: 70, chord_size: 2, chord_interval: 9);

~testSequence = ~getInterleaved.value(~strand_a, ~strand_b);

MIDIClient.init;
m = MIDIOut.new(0);
m.latency = 0;

Routine.new({
	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~strand_a, 1),
		\legato, 1,
		\dur, 1
	).play;

	0.5.wait;

	Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(~strand_b, 1),
		\legato, 1,
		\dur, 1
	).play;
}).play;
)*/