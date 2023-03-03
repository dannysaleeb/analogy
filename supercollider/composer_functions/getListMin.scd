// get the minimum value in a list
~getListMin = {
	arg list;
	var minimum=inf;
	list.do({
		arg item;
		if(
			item < minimum,
			{ minimum = item }
		);
	});
	minimum;
}