~path = thisProcess.nowExecutingPath.dirname.dirname +/+ 'midi';

m = SimpleMIDIFile.read(~path +/+ "Que todos sepassan en flores.mid");


// Get all track slices (for track 1 & 2) -- uses an extension to SimpleMIDIFile
~allSlices = m.getAllSlices(480);

// Get all MIDI intervals as a list, \none if no interval, \solo if only one part playing
(
~getIntervals = {
	arg data;
	var intervals = [], data_size=data[1].size;

	data_size.do({
		arg count;
		var interval;

		if(
			// check if midi in track 1 OR midi in track 2
			(data[1][count][0] != nil) || (data[2][count][0] != nil),
			{
				if(
					// then check if midi in both track 1 and track 2
					(data[1][count][0] != nil) && (data[2][count][0] != nil),
					{
						intervals = intervals.add((data[1][count][0] - data[2][count][0]).abs)
					},
					{
						// there must be midi in one of them, so solo
						intervals = intervals.add(\solo)
					}
				)
			},
			// no midi in either track
			{ intervals = intervals.add(\none) }
		)
	});
	intervals
};

~allIntervals = ~getIntervals.value(~allSlices);

)

// get all unique intervals from intervals list
(
~uniqueIntervals = [];

~allIntervals.do({
	arg item;
	if(
		~uniqueIntervals.indexOf(item) == nil,
		{
			~uniqueIntervals = ~uniqueIntervals.add(item)
		}
	)
})
)

// all slice intervals including \none and \solo
~allIntervals

// all unique intervals including \none and \solo
~uniqueIntervals

// for each unique interval create a dict that counts the next interval each time this unique interval occurs in ~allIntervals
(
~probsDict = Dictionary.new();

// populate dictionary with dict for each interval item
~uniqueIntervals.do({
	arg uniqueInterval;
	~probsDict.put(uniqueInterval, Dictionary.new())
});

// populate each of those dictionaries with every interval ...
~probsDict.do({
	arg dict;
	~uniqueIntervals.do({
		arg uniqueInterval;
		dict.put(uniqueInterval, 0)
	})
});

~uniqueIntervals.do({
	arg uniqueInterval;
	~allIntervals.do({
		arg interval, count;
		count.postln;
		if(
			uniqueInterval == interval,
			{
				if(
					count < (~allIntervals.size - 1),
					{
						~probsDict[uniqueInterval][~allIntervals[count + 1]] = ~probsDict[uniqueInterval][~allIntervals[count + 1]] + 1
					}
				)
			}
		)
	})
})

)

// Create function to get next value based on current interval
(
~getNext = {

	arg intervalsDict, track_size;
	var next, keys, probs;

	keys = intervalsDict.keys.asArray.sort;
	probs = keys.collect({
		arg key;
		intervalsDict[key]
	});

	next = keys.wchoose(probs.normalizeSum)

}
)

// Create function to generate music from model
(
~generate = {
	arg probDict, num_slices, seed_interval;
	var returnList = [seed_interval], generated;

	num_slices.do({
		var next;
		next = ~getNext.value(probDict[seed_interval]);
		generated = generated.add(next);
		seed_interval = next
	});

	returnList = returnList ++ generated
}
)

~newMusic = ~generate.value(~probsDict, 417, 3);


(
~outputPath = thisProcess.nowExecutingPath.dirname.dirname +/+ "output";

f = File.new(~outputPath +/+ "new_music", "w");

~generate.value(~probsDict, 417, \none).do({
	arg value;
	f.write(value.asString ++ "\n")
});

f.close;
)
