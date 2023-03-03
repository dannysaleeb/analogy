// Converts a rhythm tree (e.g. [1, -1, [1, [0, 1, 0]]]) into durations based on the given beat_dur (default 1sec).
~parseRt = {
	arg rhythm_tree, beat_dur=1;
	var returnlist = [];
	rhythm_tree.do({
		arg item, count;
		switch(
			item.class,
			Integer, {
				if(
					item == 1,
					{ returnlist = returnlist.add(beat_dur) },
					{ if(
						item.isNegative,
						{ returnlist.put(count - 1, returnlist[count - 1] + beat_dur) },
						{ returnlist = returnlist.add(Rest(beat_dur)) }
					) }
				)
			},
			Array, {
				beat_dur = beat_dur / item.size;
				returnlist = returnlist.add(~parseRt.value(item, beat_dur));
			}
		)
	});
	returnlist.flatten;
};

// Rhythm stuff needs figuring out ...

~generateRt = {
	arg beats, possible_divisions=[2,3];
	var returnlist = [], noteon=false;
	beats.do({
		arg beat;
		// for each beat, decide if the beat is going to be divided
		// if yes, then decide if it'll be divided into 2 or 3 or 5 or 7
		// if no then decided if it'll be a 1 or a 0 or a -1 (as long as the beat before was a 1 ... tracked using the noteon flag)
		if(
			// will we divide this beat?
			0.8.coin == false,
			{
				var beats = possible_divisions.choose;
				returnlist = returnlist.add(~generateRt.value(beats))
			},
			{
				// if not, will it be a 1 or something else?
				if(
					0.8.coin == true,
					// if true it's a 1
					{
						returnlist = returnlist.add(1);
						noteon = true
					},
					// if false, it's either a continuation or a zero
					{
						if(
							0.6.coin == true && noteon == true,
							// continuation if both true
							{
								returnlist = returnlist.add(-1)
							},
							// otherwise 0
							{
								returnlist = returnlist.add(0);
								noteon = false;
							}
						)
					}
				)
			}

		)
	});
	returnlist
};

// For each number from 0-9, choose whether or not to split into a new list
// then add the number to the list ... keeping track of the number you're on

~binRt = {
	arg bin, beats, count=0;
	var returnlist, tmp, bit, noteon=false;
	beats.do({
		if(
			0.4.coin == true,
			{ # tmp, count, noteon = ~binRt.value(bin, 2, count);
				returnlist = returnlist.add(tmp)
			},
			{
				bit = bin[count % bin.size];
				if(
					bit == 1 && noteon == true && 0.6.coin == true,
					{
						returnlist = returnlist.add(bit.neg);
						count = count + 1
					},
					{
						returnlist = returnlist.add(bit);
						if( bit == 1, { noteon = true }, { noteon = false });
						count = count + 1
					}
				)
				/*returnlist = returnlist.add(bin[count % bin.size]);
				count = count + 1*/
			}
		);
	});
	[returnlist, count, noteon];
};



/*-------------------------------------------*/
/*================PLAYBACK===================*/
/*-------------------------------------------*/
/*(
// MIDI setup
MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);
)

(
Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq([~me, ~you].lace, inf),
	\legato, 2,
	// create binary list from name; give shape by converting to rt; parse rt
	\dur, Pseq(~parseRt.value(~binRt.value(~asciiToBinary.value("quis es?").flatten, 4), 1), inf)
).play;
)*/