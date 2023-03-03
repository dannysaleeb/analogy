a = Explosion2D.new(20, 10, 50, 50);

~outputPath = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/[you, me].lace/output/";

(
// Print the space
a.drawFrame
)

a.reset;

(
// advance number of frames and print space
a.advanceFrames(1);
/*a.saveFrame(~outputPath, "frame_" ++ ~count ++ ".txt");
~count = ~count + 1;*/
a.drawFrame
)

(
// rewind number of frames and print space
a.rewindFrames(1);
a.drawFrame
)

(
a.advanceFrames(1);
a.getDurations(1/12).do({
	arg item;
	item.postln
});
)

(
a.getParticleDistances;
)

a.advanceFrames(1);

a.getTickDistances(1/6);
a.getDurationDistances(1/6);
~durations = a.getDurations(1/12);

~durations.pop();

~durations;
// Gets the number of ticks as a distance from the centre
// then convert the ticks to a duration, by doing tick_size


n = Explosion2D.new(20, 10, 50, 50);


(

n.goToFrame(6);
n.drawFrame

)


n.distancesFromOrigin.postln;
n.getTickDistances(0.2);
n.getDurationDistances(2);
n.getDurations(2);

n.drawFrame

n.drawFrame.do({
	arg row;
	row.postln
})

(
n.advanceFrames(1);
n.drawFrame
)

(
n.particles.do({
	arg particle;
	"=========================".postln;
	("X coord is" + particle.x).postln;
	("Y coord is" + particle.y).postln;
	"=========================".postln
})
)

~count = 0;

(
n.advanceFrames(1);
n.drawFrame;
n.drawFrame2File(~outputPath, "frame_" ++ ~count ++ ".txt");
~count = ~count + 1;
)

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
p = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~me_b.flatten, inf),
		\legato, 1,
		\amp, 0.6,
		\dur, Pseq([~durations, Rest(2)].flatten, inf),
	).trace.play(quant: 2);
)

(
r = Routine.new({
	a = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 0,
		\midicmd, \noteOn,
		\midinote, Pseq(~me_b.flatten, 1),
		\legato, 1,
		\amp, 0.6,
		\dur, 1,
	).trace.play(quant: 2);

	8.wait;

	b = Pbind(
		\type, \midi,
		\midiout, m,
		\chan, 1,
		\midicmd, \noteOn,
		\midinote, Pseq(~me, 1),
		\legato, 1,
		\amp, 0.6,
		\dur, 2/3,
	).trace.play(quant: 2);

}).play
)

r.next;

(
a.pause;
b.pause;
)

(
a.play;
b.play;
)