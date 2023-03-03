// Functions for constraining sequences of pitches or chords.

/*RETURNS MIDINOTE (OR NOTE) WITHIN THE GIVEN RANGE (DEFINED BY lower AND upper)*/
~constrainPitch = {
	arg lower, upper, pitch;
	if(
		pitch > upper,
		{
			var diff, octave_dist;
			diff = pitch - upper;
			octave_dist = (diff / 12).ceil.asInteger;
			pitch - (octave_dist * 12)
		},
		{
			if(
				pitch < lower,
				{
					var diff, octave_dist;
					diff = lower - pitch;
					octave_dist = (diff / 12).ceil.asInteger;
					pitch + (octave_dist * 12)
				},
				{
					pitch
				}
			)
		}
	)
};

~constrainSeq1 = {
	arg lower, upper, sequence;
	sequence.collect({
		arg pitch;
		~constrainPitch.value(lower, upper, pitch);
	})
};

~constrainChords1 = {
	arg lower, upper, sequence;
	var returnlist = [];
	sequence.do({
		arg chord;
		var chordlist=[];
		chord.do({
			arg pitch;
			chordlist = chordlist.add(~constrainPitch.value(lower, upper, pitch))
		});
		returnlist = returnlist.add(chordlist)
	});
	returnlist
}

/*-------------------------------------------*/
/*================PLAYBACK===================*/
/*-------------------------------------------*/
/*(
// MIDI setup
MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);
)

~binSelect.value("danny", p, mode: "ascii");

(
Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq(~you_a, 1),
	\legato, 2,
	\dur, Pseq(~parseRt.value([1, -1, [0, 1]], 0.25), inf)
).play;
)

s.quit;*/
