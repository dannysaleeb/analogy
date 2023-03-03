// compares two lists of values and returns a number that represents how similar they are to each other -- the lower the number, the more similar they are.
(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["getMax", "getMin"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
})
);

~getSimVal = {
	arg thos, thot;
	var differenceTotal = 0, difference;
	thos.size.do({
		arg i;
		difference = ~getMax.value(thos[i], thot[i]) - ~getMin.value(thos[i], thot[i]);
		differenceTotal = differenceTotal + difference;
	});
	differenceTotal;
}