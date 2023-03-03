// 1. function for sequence roots
// 2. function for playing chords of sequence
// 3. function for determining voice-leading?
// 2. function for creating rhythmic values from text (morse and binary)

// need to look at how durational values are represented ... go back to Eli Fieldsteel tutorial

// Each Pbind is a voice, I guess? So need to create the midinote collections before they are played.

MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);

(
// INITIATE FUNCTIONS

/*THIS FUNCTION GETS SEQUENCE ROOTS AS A REPEATABLE LIST*/
~sequenceRoots = {
	arg intervals=[-3, 1], refDegree=7, scale=Scale.major, cycles=scale.degrees.size;
	var return = [refDegree];
	return = return.add(
		cycles.collect(
			{
				intervals.collect(
					{
						arg interval;
						refDegree = refDegree + interval;

					};
				)
			}
		).flatten;
	).flatten;
	return.removeAt(return.size-1);
	return;
};

/*THIS FUNCTION GETS SEQUENCE CHORDS BASED ON ROOTS*/
// Could add functionality to check for an inversion value?
~sequenceChords = {
	arg roots;
	roots.collect({
		arg root;
		root = [root, root+2, root+4];
		// here add rotation depending on inversion value
	})
};
)

(
~invertChord = {
	arg chord, scaleSize, inversion;
	inversion.do({
		chord = chord.rotate(-1);
		chord[chord.size - 1] = chord[chord.size - 1] + scaleSize;
	});
	chord.postln;
	// this affects the original chord ...
}
)

r = [0,2,4];

~invertChord.value(chord: r, scaleSize: 7, inversion: 4);

r;

(
n = ~sequenceRoots.value(intervals: [-3, 1], refDegree: 0, scale: Scale.minorPentatonic);

q = ~sequenceRoots.value(intervals: [-3,1], refDegree: 2, scale: Scale.minorPentatonic);

// maybe this can be produced in one go? and this is raw material rather than based on initial roots sequence?
o = ~sequenceChords.value(n);

)

(
// Generate random inversions of chords and then plug into Pbind...
// Could also analyse each chord to try to get good voice leading...
3.rand;

o = o.collect({
	arg chord;
	var num = 3.rand;
	~invertChord.value(chord, 7, num);
})
)

o;

(
~textToBinary = {
	arg text;
	var return = [];

	text.do({
		arg char;
		return = return.add(char.ascii.asBinaryDigits);
	});
	return;
}
)

// Instead, could give rests where zeros ... so need to additionally create a durations collection (giving a duration for each chord OR rest)
(
~sequenceToDurations = {
	arg sequence, text;
	var binary = ~textToBinary.value(text).flatten, noteReturn = [], durReturn = [];
	binary.do({
		arg digit, count;
		if(
			digit == 1,
			{
				noteReturn = noteReturn.add(sequence[count % sequence.size]);
				durReturn = durReturn.add(2.0.rand);
			},
			{ durReturn = durReturn.add(Rest(1.0.rand))
			}
		);
	});
	[noteReturn, durReturn];
}
)

x = ~sequenceToDurations.value(o, "Quis es?");

// How then do I translate the degrees to specifically voiced pitches?

// I think this could be the basis for the piano piece ... this kind of technique. Something to do with varying thickness of chords v. single notes.
// SAVE THIS ONE
z = o;

(
p = Pbind(
	\type, \midi,
	\midiout, m,
	\midicmd, \noteOn,
	\scale, Scale.major,
	\degree, Pseq(x[0], inf),
	\legato, 10,
	\dur, Pseq(x[1], inf)
).trace.play;
)

// The degrees are applied to whatever scale -- could make more concrete by getting actual midi values before giving degrees to Pbind ... and give midi values to Pbind instead...

// This is really fucking cool ... because you can change the scale it's applied to ... without having to factor in at the start...

// Next ... work out how to get inside the chords ... could separate into voices ...

// can separate them out ... but maybe better to convert them to midi numbers and then check which are closest ... there must be an algorithm to write for checking which inversion to use next ...




/* example reference
Pbind(
	\type, \midi,
/*	\midicmd, \noteOn,*/
	\midiout, m,
	\chan, 0,
	\midinote, Pseq(o, inf),
	\legato, 1.5,
	// \amp, Pseq([0.5, 0.2, 0.7], inf),
	// \sustain, 0.2,
	// \dur, 0.5,
).trace.play;
*/