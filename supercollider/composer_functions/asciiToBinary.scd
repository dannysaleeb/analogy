// Converts text to a list of binary digits based on ascii values
~asciiToBinary = {
	arg text;
	var return = [];

	text.do({
		arg char;
		return = return.add(char.ascii.asBinaryDigits);
	});
	return;
}