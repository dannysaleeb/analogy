Chord {
	var <midivals;

	*new { | midivals |
        ^super.newCopyArgs(midivals)
    }

	size {
		^this.midivals.size
	}

	chordGraph {
		var return;
		return = this.midivals.collect({
			arg midi_value_i, count;
			this.midivals.collect({
				arg midi_value_j, count;
				var edge_value = midi_value_j - midi_value_i;
				if( edge_value.isNegative, { edge_value.neg }, { edge_value } )
			})
		});
		/*return.do({
			arg item;
			item.asString.postln;
		});*/
		^return
	}

	uniqueIntervalCoords {
		var return;
		Array.series(this.size).powerset.do({
			arg item;
			if(item.size==2,{return=return.add(item)},{nil})
		});
		^return
	}

	// Need this to return a dict really ... in fact the chord ought
	// to be expressed as a dict -- chord tones need ids
	uniqueIntervals {
		var return, graph, coords;
		graph = this.chordGraph;
		coords = this.uniqueIntervalCoords;
		coords.do({
			arg coord;
			return = return.add(graph[coord[0]][coord[1]])
		});
		^return
	}

}
