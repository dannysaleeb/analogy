// Bit of a dodgy one this -- converts binary digits based on text to a list of notes and corresponding durations (including some rests)
~sequenceToDurations = {
	arg sequence, text;
	var binary = ~textToBinary.value(text).flatten, noteReturn = [], durReturn = [];
	binary.do({
		arg digit, count;
		if(
			digit == 1,
			{
				noteReturn = noteReturn.add(sequence[count % sequence.size]);
				durReturn = durReturn.add(2.0.rand);
			},
			{ durReturn = durReturn.add(Rest(1.0.rand))
			}
		);
	});
	[noteReturn, durReturn];
}