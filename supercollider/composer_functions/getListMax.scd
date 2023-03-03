// get maximum value from list
~getListMax = {
	arg list;
	var maximum = -inf;
	list.do({
		arg item;
		if(
			item > maximum,
			{ maximum = item }
		);
	});
	maximum;
}