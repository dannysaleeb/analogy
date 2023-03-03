(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";

// Load helpers
["sequenceRoots", "getMin", "getMax", "compare", "getSimVal", "sequenceChords", "degToMIDI", "getOctave", "invertChord", "textToBinary"].do({
	arg function;
	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
})
)

/*-------------------------------------------*/
/*=================SKETCH====================*/
/*-------------------------------------------*/


//
// DEFINING ME & YOU WITH BINARY ASCII-->BINARY
//
(
var me, you, me_and_you, me_bin, you_bin, me_and_you_bin, me_select = [], you_select = [];

// Define parent names
me = "Danny".asList;
you = "Kitty".asList;

// Get binary data for each
me_bin = ~textToBinary.value(me).flatten;
you_bin = ~textToBinary.value(you).flatten;
me_and_you_bin = ~textToBinary.value(me_and_you).flatten;

me_bin.do({
	arg bin, count;
	if(
		bin == 1,
		{ me_select = me_select.add(~me_dna[count % ~me_dna.size]) }
	);
});

you_bin.do({
	arg bin, count;
	if(
		bin == 1,
		{ you_select = you_select.add(~you_dna[count % ~you_dna.size]) }
	);
});

~me = me_select;
~you = you_select;
)



(
// The complete sequence, when combined (number of repeated rounds to allow these to come back into phase)
~youme_me = ~you.size.collect({
	arg num;
	~me;
}).flatten;

~youme_you = ~me.size.collect({
	arg num;
	~you;
}).flatten;
)

// [me, you].lace
~youme = [~me, ~you].lace(~me.size * ~you.size);

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

