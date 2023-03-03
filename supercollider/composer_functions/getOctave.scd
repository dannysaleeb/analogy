// gets the octave level of a degree relative to degree 0
~getOctave = {
	arg degree, scale_size;
	var octave, amount;
	amount = degree / scale_size;
	octave = amount.floor.asInteger;
	octave;
}