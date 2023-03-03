s.boot;

(
SynthDef.new("felix", {
	arg freq=200, amp=0.2, out=0;
	var sig;
	sig = SinOsc.ar(freq) * Line.kr(0.7, 0, 1, doneAction: 2);
	Out.ar(out, sig);
}).add
)

x = Synth.new(\felix, [\freq, 300]);

s.plotTree;

(
{
	var sig, env, freq1, freq2, freq3, freq4, offset1=4, offset2=6;
	freq1 = ExpRand(30, 500);
	freq2 = freq1 + offset1;
	freq3 = ExpRand(30, 500);
	freq4 = freq3 + offset2;
	env = EnvGen.kr(Env.new(
		[0.01, 1, 0.2, 0.01],
		[0.5, 1, 2],
		\exp),
	    doneAction: 2);
	sig = [Saw.ar(freq1) + Saw.ar(freq2), SinOsc.ar(freq3) + SinOsc.ar(freq4)] * env;
}.play;
)


Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], \exp).plot;