// Make binarySelect and then use morseToBinary and asciiToBinary as separate functions to feed it
~binarySelect = {
	arg binary, sequence, offset=0, all=true;
	var morse_bin, return_chords=[];

	/*morse_bin = ~morseWordToBinary.value(text);
	morse_bin = morse_bin.add([0,0]).flatten;*/

	if(
		all == true,
		{
			sequence.size.do({
				arg num;
				// for each bit in morse_bin, if it is a 1, select chord at that index in sequence, relative to some starting position (num)
				binary.do({
					arg bit, count;
					if(
						bit == 1,
						{ return_chords = return_chords.add(sequence[(count + num) % sequence.size]) }
					);
				});
			});
		},
		{
			binary.do({
				arg bit, count;
				if(
					bit == 1,
					{ return_chords = return_chords.add(sequence[(count + offset) % sequence.size]) }
				);
			});
		}
	);

	return_chords;
}