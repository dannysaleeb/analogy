// a bit broken function could be improved ...
~compareScales = {
	arg scale, other;
	var return, temp;
	other.size.do({
		arg i;
		temp = other.rotate(i);
		// would be good to do this until a match is found -- need a way to break loop
		// better in python ...
		block {
			arg break;
			other.size.do({
				arg j;
				if(
					temp[j] == scale[j],
					{
						return = temp;
						break.value(return);
					}
				);
			});
		}
		/*if(
			temp[0] == scale[0],
			{ return = temp }
		);*/
	});
	return;
}