s.boot;


(
var collection1, collection2, ultraCollection;

collection1 = Scale.major.degrees.collect{
	arg item;
	var midi;
	midi = 60 + item;
};

collection2 = Scale.major.degrees.collect{
	arg item;
	var midi;
	midi = 64 + item;
};

ultraCollection = Array.new(2);

ultraCollection.add(collection1);
ultraCollection.add(collection2);

// a way of interleaving the patterns ...
b = ultraCollection.lace();


SynthDef(\synth1, {
	arg freq, amp, out;
	var sig;
	sig = SinOsc.ar(freq, 0, amp);
	Out.ar(out, sig);
}).add;

b.do{
		arg item, count;
		c = Synth(\synth1, [\freq, item.midicps, \amp, 0.05]);

};

)

s.freeAll;
