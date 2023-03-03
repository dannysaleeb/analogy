// I want this to spit out ... midi values?n based on a specific scale ...
~sequenceRoots = {
	arg intervals=[-3, 1], refDegree=0, cycles=7;
	var return = [refDegree];
	return = return.add(
		cycles.collect(
			{
				intervals.collect(
					{
						arg interval;
						refDegree = refDegree + interval;

					};
				)
			}
		).flatten;
	).flatten;
	return.removeAt(return.size-1);
	return;
};
