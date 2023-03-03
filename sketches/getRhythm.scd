// Generates 10 random rhythms up to 2secs, including rests
~getRhythm = {
	var return = [], boolean;

	10.do({
		arg num;
		boolean = 2.rand;
		if(
			boolean == 1,
			{
				if(
					num != 0,
					{return = return.add(1/num)},
					{return = return.add(num)}
				);
			},
			{
				if(
					num != 0,
					{return = return.add(Rest(1/num))},
					{return = return.add(Rest(num))}
				);
			}
		);
	});
	return;
}