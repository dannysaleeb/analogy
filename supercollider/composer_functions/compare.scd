// compares two lists of values, thos and thot, returning the rotation of thot that is most similar to thos.
~compare = {
	arg thos, thot;
	var optimum, tmp, simValues = [], winner;
	optimum = ~getSimVal.value(thos, thot);
	winner = thot;
	thos.size.do({
		arg i;
		tmp = ~getSimVal.value(thos, thot.rotate(i));
		simValues = simValues.add(tmp);
		if(
			tmp < optimum,
			{ optimum = tmp; winner = thot.rotate(i); }
		);
	});
	winner;
}