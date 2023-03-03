// Attempts to drop notes of other scale into the range of this scale.
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
	});
}