// MATERIAL FOR SIBLINGS

MIDIClient.init;

m = MIDIOut.new(0);
m.latency(0);

// I want this to spit out ... midi values?n based on a specific scale ...
(
~sequenceRoots = {
	arg intervals=[-3, 1], refDegree=0, scale=Scale.major, cycles=scale.degrees.size;
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
)

// create base sequence degrees
x = ~sequenceRoots.value;

// generate midi values based on sequence of degrees
(
x = x.collect({
	arg degree;
	~degreeToMIDI.value(degree, 60, Scale.minorPentatonic);
})
)

// this one is the same but ... modulates
(
~modulatingCollection = [];
12.do({
	arg num;
	x.do({
		arg degree;
		~modulatingCollection = ~modulatingCollection.add(~degreeToMIDI.value(degree, 60 + (num * 7), Scale.major));
	});
});
~modulatingCollection;
)

y = [0, 1, 2, 3, 4, 5, 6];

y;

(
~modulateAgain = {
	arg degrees;
	var thos, thot, return=[], forComparison;
	thos = degrees.collect({
		arg degree;
		~degreeToMIDI.value(degree, 60, Scale.major);
	});
	// add first scale to thos
	return = return.add(thos);
	12.do({
		arg num;
		/*thos = degrees.collect({
			arg degree;
			~degreeToMIDI.value(degree, 60 + (num * 7), Scale.major);
		});*/
		thot = degrees.collect({
			arg degree;
			~degreeToMIDI.value(degree, 60 + ((num + 1) * 7), Scale.major);
		});
		forComparison = ~normalizeMIDI.value(thos, thot).postln;
		return = return.add(~compare.value(thos, forComparison)).postln;
	});
	return;
}
)

~newCollection = ~modulateAgain.value(x);

block {
	|break|
	100.do {
		|i|
		i.postln;
		if (i == 5) { break.value('broken') }
	};
}

(
~compareScales = {
	arg scale, other;
	var return, temp;
	other.size.do({
		arg i;
		temp = other.rotate(i);
		// would be good to do this until a match is found -- need a way to break loop
		// better in python ...
		block {
			arg break;
			other.size.do({
				arg j;
				if(
					temp[j] == scale[j],
					{
						return = temp;
						break.value(return);
					}
				);
			});
		}
		/*if(
			temp[0] == scale[0],
			{ return = temp }
		);*/
	});
	return;
}
)

~compareScales.value([65,67,68,70], [68, 69, 66, 67]);

(
{
	var return = [];
	12.do({
		arg num;
		return = return.add(
			y.collect({
				arg degree;
				~degreeToMIDI.value(degree, 60 + num, Scale.major);
			}).rotate(4);
		);
		return.postln;
	})
}.value;
)

(
~modulatingScales = {
	var return, thisScale, otherScale;
	12.do({
		arg num;
		return = return.add(
			y.collect({
				arg degree;
				~degreeToMIDI.value(degree, 60 + (num * 7), Scale.major)
			})
		)
	})
}
)

(
~getListMin = {
	arg list;
	var minimum=inf;
	list.do({
		arg item;
		if(
			item < minimum,
			{ minimum = item }
		);
	});
	minimum;
}
)

(
~getListMax = {
	arg list;
	var maximum = -inf;
	list.do({
		arg item;
		if(
			item > maximum,
			{ maximum = item }
		);
	});
	maximum;
}
)

(
~getMin = {
	arg a, b;
	var min;
	if(
		a == b,
		{ min = a },
		{
			if(
				a > b,
				{ min = b },
				{ min = a }
			);
		}
	);
	min;
}
)

(
~getMax = {
	arg a, b;
	var max;
	if(
		a == b,
		{ max = a },
		{
			if(
				a > b,
				{ max = a },
				{ max = b }
			);
		}
	);
	max;
}
)

~getMax.value(7,7);

~getMin.value(5, 4);

a = [60, 62, 64, 65, 67, 69, 71];
b = [67, 69, 71, 72, 74, 76, 78] + 7;
c = ~normalizeMIDI.value(a, b);

(
~getSimilarityValue = {
	arg thos, thot;
	var differenceTotal = 0, difference;
	thos.size.do({
		arg i;
		difference = ~getMax.value(thos[i], thot[i]) - ~getMin.value(thos[i], thot[i]);
		differenceTotal = differenceTotal + difference;
	});
	differenceTotal;
}
)

~getSimilarityValue.value(a, b);

// This returns the most similarly positioned group of notes
(
~compare = {
	arg thos, thot;
	var optimum, tmp, simValues = [], winner;
	optimum = ~getSimilarityValue.value(thos, thot);
	winner = thot;
	thos.size.do({
		arg i;
		tmp = ~getSimilarityValue.value(thos, thot.rotate(i));
		simValues = simValues.add(tmp);
		if(
			tmp < optimum,
			{ optimum = tmp; winner = thot.rotate(i); }
		);
	});
	winner;
}
)

~compare.value(a, c);

(
7.do({
	arg i;
	var return;
	return = c.rotate(i).postln;
})
)

(
~normalizeMIDI = {
	arg thisScale, otherScale, octave;
	otherScale.collect({
		arg midinote;
		if(
			midinote > ~getListMax.value(thisScale),
			// need to add number of octaves depending on how much bigger...
			{
				octave = ((midinote - ~getListMax.value(thisScale)) / 12).floor.asInteger;
				octave.postln;
				midinote = midinote - (12 * (octave + 1))
			},
			{ midinote }
		);
	}).postln;
}
)

// Currently this performs a rotation with the highest note of the original scale as the ceiling
~normalizeMIDI.value([60,62,64,65,67,69,71], [67,69,71,72,74,76,78]);


// HOW CAN I GET THE PITCH LEVEL TO START IN THE SAME PLACE? ROTATE AND CHECK TO SEE IF MATCH IS CLOSE? MAKE THE FUNCTION GENERIC SOMEHOW ...


// helper function to get the octave level of the degree.
(
~getOctave = {
	arg degree, scale_size;
	var octave, amount;
	amount = degree / scale_size;
	octave = amount.floor.asInteger;
	octave;
}
)

// helper function to get midi value from degree given a specific scale
(
~degreeToMIDI = {
	arg degree=4, root_midi=60, scale=Scale.major;
	var midivalue;
	midivalue = scale.degrees[degree % scale.size] + root_midi + (~getOctave.value(degree, scale.size) * 12);
	midivalue;
}
)

~getOctave.value();

x = ~degreeToMIDI.value(5, 60, Scale.minorPentatonic);


(
// Child 1
p = Pbind(
	\type, \midi,
	\midiout, m,
	\midicmd, \noteOn,
	\scale, Scale.minorPentatonic,
	\midinote, Pseq(~newCollection.flatten, inf),
	\legato, 10,
	\dur, 0.25
).trace.play;
)
