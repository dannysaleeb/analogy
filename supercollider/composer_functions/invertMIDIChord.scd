// Inverts MIDI Chord
~invertMIDIChord = {
	arg chord, inversion;
	var chord_copy;
	chord_copy = chord;
	if( inversion.isNegative == true,
		{
			inversion.neg.do({
				chord_copy = chord_copy.rotate;
				chord_copy[0] = chord_copy[0] - 12;
			})
		},
		{
			inversion.do({
				chord_copy = chord_copy.rotate(-1);
				chord_copy[chord_copy.size - 1] = chord_copy[chord_copy.size - 1] + 12;
			})
		}
	);
	chord_copy
}