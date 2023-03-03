s.boot;
s.plotTree;

(
{
	var sig, env;
	env = XLine.kr(1, 0.01, 1, doneAction: 2);
	sig = Pulse.ar(ExpRand(30,500)) * env;
}.play;
)



s.freeAll;

// What do I need from SuperCollider???? MIDI ... & tuning?