s.quit;
s.boot;

(
SynthDef.new(\pulseTest, {
	arg ampHz=4, fund=40, minPartial=5, maxPartial=11, width=0.5;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund*minPartial, fund*maxPartial).round(fund);
	freq2 = LFNoise0.kr(4).exprange(fund*minPartial, fund*maxPartial).round(fund);
	freq1 = freq1 * 5;
	freq2 = freq2 * 5;
	// freq1 = freq1 * LFPulse.kr(8);
	// freq2 = freq2 * LFPulse.kr(6);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	// sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	// sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, [sig1, sig2]);
}).add;
)

// Plus "GREEN" morse might be nice ... look at patterns ...

x = Synth.new(\pulseTest);

x.set(\maxPartial, 100, \minPartial, 60);
x.set(\fund, 101);

x.free;

// Use noise -- filter wanted notes only ... make trees ... 