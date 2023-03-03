~space2time = {
	arg coords, space_size=50;
	var space = [[], []];

	// Create negative and positive horizontal space as lists of 0s given space_size
	space_size.do({
		space[0] = space[0].add(0);
		space[1] = space[1].add(0);
	});

	// Insert 1s at indices given by the list of x-coords
	coords.do({
		arg coord;
		if(
			coord.isNegative == true,
			{
				space[0].put(coord.neg, 1)
			},
			{
				space[1].put(coord, 1)
			}
		)
	});
	// reverse the negative space, to reflect particles bursting outwards from centre
	space = [space[0].reverse, space[1]];
	space
}

~coords = [-20, -10, -8, -7, -5, -4, -3, -2, -1, 0, 1, 2, 3, 5, 7, 9, 12, 20, 25];

~space2time.value(~coords);

~parseSpace = {
	arg coordsSpace, tick_dur;
	var dur_list;

	// Go through the negative space and add duration where 1, rest where 0
	coordsSpace[0].do({
		arg tick;
		if(
			tick == 1,
			{
				dur_list = dur_list.add(tick_dur)
			},
			{
				dur_list = dur_list.add(Rest(tick_dur))
			}
		)
	});
	// Go through the positive space and add duration where 1, rest where 0
	coordsSpace[1].do({
		arg tick;
		if(
			tick == 1,
			{
				dur_list = dur_list.add(tick_dur)
			},
			{
				dur_list = dur_list.add(Rest(tick_dur))
			}
		)
	});
	dur_list
}

~durations_a = ~parseSpace.value(~space2time.value(~coords), 1/12);

// Actually this just creates an effect of contraction and expansion.


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
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~me_b.flatten, inf),
		\legato, 1,
		\amp, 0.6,
		\dur, Pseq(~durations_a, inf)
	);
).play(quant: 2);
)