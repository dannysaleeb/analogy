// get minimum value in a pair (returns either if they are matching)
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