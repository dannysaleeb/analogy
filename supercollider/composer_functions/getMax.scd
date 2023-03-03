// get maximum value from a pair (returns the first if they are matching)
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