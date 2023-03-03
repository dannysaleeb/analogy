s.reboot;

(
OSCdef(\whatever,
	{arg msg; msg.postln},
	'/stuff'
)
)

(
SynthDef.new(\sawtone, {
	arg freq, amp=0.2, out;
	var sig;
	amp = PinkNoise.kr();
	sig = Saw.ar(freq, 0.1) * EnvGen.kr(Env([0,1,0], [1,2]));
	Out.ar(out, sig!2);
}).add;
)

// This will play my created scale ... but what scale to create?
(
~scale1 = Scale.minorPentatonic;

Routine.new(
	{
		(0..~scale1.degrees.size).mirror.do({
			arg degree, index, chord_size=3, note_diff=2;
			// play chords
			if (
				index % 2 == 0,
				{degree = degree - 4},
				{degree = degree + 1}
			);
			chord_size.do({
				arg num;
				Synth.new(\sawtone, [\freq, ~scale1.degreeToFreq((degree + (num * note_diff)), 48.midicps, 0)]);
			});
			1.wait;
		});
	}
).play;
)

s.freeAll;

// how to play chords based on the notes of the scale?
Scale.directory;