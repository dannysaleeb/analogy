s.boot;
s.quit;

// use lfo to change the frequency of these within a certain range ... or use pink noise?

//

(
SynthDef(\pinktest, {
	arg out;
	Out.ar(
		out,
		SinOsc.ar(PinkNoise(100))
	)
}).add
)

// Use this for something ... the city crickets
a = {Pulse.ar([LFNoise0.kr(2).range(1, 10), LFNoise0.kr(2).range(1, 10)], mul: 0.1)}.play


{RLPF.ar(Dust.ar([1, 5]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.02)}.play

{Pulse.ar(freq: MouseX.kr(300, 2500), mul: MouseY.kr(0, 1))}.scope.play

{ Pulse.ar }.plot;
{ Saw.ar }.plot;
{ SinOsc.ar }.plot;
{ LFPulse.ar }.plot

(
SynthDef(\2, {
	arg out;
	Out.ar(
		out,
		Pulse.ar(0.2, add: 0.4)
	)
}).add
)

(
SynthDef(\3, {
	arg out;
	Out.ar(
		out,
		Pulse.ar(0.3, add: 0.4)
	)
}).add
)

f = {Out.ar(2, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play

n = {Out.ar(55, WhiteNoise.ar(0.5))}.play

(
a = Synth(\1);
b = Synth(\2);
c = Synth(\3);
)

a = Synth(\pinktest)

{SinOsc.ar(LFNoise0.kr(5).range(5, 7) * 100)}.play

{SinOsc.ar(LFPulse.kr(LFNoise0.kr(100)).range(0, 1))}.play

// LFPulse cycles between 0 and 1 some number of times per second according to freq
{LFPulse.ar(0.5).poll}.scope.play

// Noise generator is getting 10 random number between 1 & -1 per second, which are scaled to being between 0 & 100, which are feeding the frequency argument of LFPulse, which is producing the numbers 220 & 300 alternately at a rate dictated by LFNoise, which is in turn fed to the SinOsc UGen as frequency paramter.
{SinOsc.ar(LFPulse.kr(LFNoise0.kr(10).range(0,100)).range(220, 300))}.play
// Flippin mental

// EQUIVALENT
{SinOsc.kr(1).range(100,200).poll}.play
{SinOsc.kr(1, 0, 50, 150).poll}.play

// EQUIVALENT
{LFPulse.kr(1).range(100, 200).poll}.play
{LFPulse.kr(1, mul: 100, add: 100).poll}.play

{LFNoise0.ar(2).poll}.play

a = [1, 2, 3, 4, 5, 6, 7];
a.linexp(1, 7, 0.01, 127).round(1);

s.meter
s.boot

ServerMeter.new(s, 2, 20)

(
OSCdef(
	key: \whatever,
	func: {arg pitch; pitch.postln},
	path: '/gyro'
)
)

// AUDIO BUSES
{Out.ar(2, SinOsc.ar(220, 0, 0.1))}.play

// MIC INPUT
{SoundIn.ar([0,1])}.play

{FreeVerb.ar(SoundIn.ar(), mix: 0.5, room: 0.9)}.play

// MULTICHANNEL EXPANSION
{Out.ar(0, Saw.ar(freq: [440, 570, 880], mul: Line.kr(0, 1, 10)))}.play

// BUS OBJECT
r = {Out.ar(0, FreeVerb.ar(In.ar(~myBus, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play

a = {Out.ar(~myBus, SinOsc.ar([800, 860], mul: LFPulse.kr(2)))}.play

~myBus = Bus.audio(s, 2);

// PANNING
p = {Pan2.ar(in: PinkNoise.ar, pos: SinOsc.kr(2), level: 0.1)}.play

// This is amusing -- warbling women
{ SinOsc.ar(LFNoise1.kr([10, 12]).range(220, 880), mul: 0.1) }.play

(
x = {
	// noise generates a random value between 1 & -1
	var lfn = LFNoise0.kr(1);
	var saw = Saw.ar(
		freq: 30,
		// amplitude controlled by a changing LFPulse
		mul: LFPulse.kr(
			freq: LFNoise1.kr(1).range(1, 10),
			width: 0.1));
	var bpf = BPF.ar(in: saw, freq: lfn.range(500,2500), rq: 0.5, mul: 20);
	Pan2.ar(in: bpf, pos:lfn);
}.play
)

x.free

~mySaw = {Saw.ar(30)}

l = {arg freq = 30; BPF.ar(~mySaw, freq)}.play

l.set(\freq, 50)

// Mix and Splay
a = {SinOsc.ar([100,300,500,700,900], mul: 0.1)}.play;
a.free

ServerMeter.new(s, 2, 100);

b = { Mix(SinOsc.ar([100,300,500,700,900], mul: 0.1))}.play;
b.free

c = { Splay.ar(SinOsc.ar([100,300,500,700,900], mul: 0.1))}.play;
c.free

(
d = {
	arg fundamental = 110;
	var harmonics = [11, 12, 13, 14, 15, 16, 17];
	var snd = BPF.ar(
		in: Saw.ar(32, LFPulse.ar(harmonics, width: 0.1)),
		freq: harmonics * fundamental,
		rq: 0.01,
		mul: 20);
	Splay.ar(snd);
}.play
)

d.set(\fundamental, 100);
