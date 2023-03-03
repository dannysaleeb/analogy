s.boot;

// DOING MIDI
MIDIClient.init;

m = MIDIOut.new(0);

m.latency = 0;
m.noteOn(0, 60, 30);
m.noteOff(0, 60);


Routine({
	[35,49,56,63,66,73].do(
		{
			arg nn;
			m.noteOn(0, nn, 0);
			(1/nn).wait;
		}
	)
}).play;



n = 12.collect(
	{
		rand(127);
	}
)

// This might be nice for duetting with computer as a first piece ... something silly ... what would be actually playing the computer part? Maybe the disklavier...
~savedCycle;

~poop = Pbind(
	\type, \midi,
/*	\midicmd, \noteOn,*/
	\midiout, m,
	// \chan, 0,
	\midinote, Pseq(n, inf),
	\legato, 1.5,
	// \amp, Pseq([0.5, 0.2, 0.7], inf),
	// \sustain, 0.2,
	// \dur, 0.5,
).trace.play;

~poop.stop;

//
//
//
// SOME PRACTICE FROM RUVIARO
{SinOsc.ar([LFNoise0.kr(2).range(500, 1000), LFNoise0.kr(2).range(500, 1000)], mul: 0.1)}.play;

// Rain???
{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([20, 25]).range(1000, 2000), 0.1)}.play;

// Could add some resonance to some of them ... so randomly gives some of these impulses a tail, or some roundness ...
//
//
//
//

// This is super nice ... could be good way of doing tree tinkles ...

//
//
// This function is all that's needed for creating harmonic sequences... not actually very complicated...
~sequenceCreator = {
	arg intervals=[-3, 1], refDegree=7, scale=Scale.major, cycles=scale.degrees.size;
	var return;
	return = cycles.collect(
		{
			intervals.collect(
				{
					arg interval;
					refDegree = refDegree + interval;
					refDegree;

				};
			)
		}
	).flatten
}
//
//
//
//

(
p = Pbind(
	\degree, Pseq(~sequenceCreator.value, inf),
	\dur, Pseq([0.2, 0.1, 0.1], inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, 0.1
);

p.play;

)

Pbind(
	\freq, Pwhite(1,12) * 400,
	\dur, Pseq([0.2,0.1,0.1] * 2, inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, 1.5
).trace.play;

s.stopRecording;

// for the trees ... need to have it multicoloured, and then gradually come down to Green G ... and Rain Will Fall ...

s.quit;