s.boot;
(
x = Pbind(
	\instrument, \default,
	\degree, Pseq([[0,4,7,9],[3,4,5]], inf),
	\scale, c,
).play
)


/*-------------------------------------------*/
/*=================TESTS=====================*/
/*-------------------------------------------*/
MIDIClient.init;
m = MIDIOut.new(0)
m.latency = 0;

(
p = Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\degree, Pseq([[0,2,4]], inf),
	\legato, 0.8,
	\scale, Scale.major,
	\dur, 2
	).trace.play;
)
)

p.stop

a = Scale.major;

a.tuning_

Tuning.new([0, -8, 4, -26, -14, -22, -10, 2, -28, 6, -24, -12], name: \testtune);

b = Scale.new([0, 2, 4, 5, 7, 9, 11], 12, c);

c = Tuning.just;

c.cents
c.semitones

c.ratios

d = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
c.ratios

(d * c.ratios).postln

2 * c.ratios[2]

[1, 2] * [3, 4]

c.semitones
d * c.ratios

a = Scala.new("/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/The Promise/Sketches/tunings/thePromise")

a.scale

a.semitones

b = Tuning.new(a.semitones, name: \promise);
c = Scale.new([0,2,4,5,7,9,11], 12, tuning: b);

d = a.scale;

d;

a.semitones
