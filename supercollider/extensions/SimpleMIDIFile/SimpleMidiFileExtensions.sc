+ SimpleMIDIFile {

	getTrackSlices {
		arg track_events, slice_size;
		var count=0, playing=[], returnDict = Dictionary.new();

		this.length.do({
			arg tick;
			if(
				tick % slice_size == 0,
				{
					count = count + 1;
					track_events.do({
						arg event;
						if(
							event[1] == tick && event[2] == \noteOn,
							{
								playing.add(event[4]);
							},
							{
								if(
									event[1] == tick && event[2] == \noteOff,
									{
										playing.do({
											arg note;
											if(
												note == event[4],
												{
													playing.removeAt(playing.indexOf(note))
												}
											)
										})
									}
								)
							}
						);
					});
					returnDict = returnDict.put(count - 1, [] ++ playing);
				}
			)
		});
		^returnDict
	}

	getAllSlices {
		// I want this to return a dictionary for each music track?
		arg slice_size;
		var num_tracks=this.tracks-1, returnDict = Dictionary.new();

		// for each track, do getSlices and add to the returnDict...
		num_tracks.do({
			arg track_num;
			var track_events;

			track_num = track_num + 1;
			track_events = this.midiTrackEvents(track_num);

			returnDict.put(track_num, this.getTrackSlices(track_events, slice_size))

		});

		^returnDict

	}

}

// Probability model is fe

