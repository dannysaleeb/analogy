~dnaStrand = {

	arg pattern=[-4,3], root=60, chord_size=3, chord_interval=3, scale=Scale.major, inversions=false;
	var parent, chordsMIDI;

	/*-------------------------------------------*/
	/*===============IMPORTS=====================*/
	/*-------------------------------------------*/
	~path = thisProcess.nowExecutingPath.dirname;

	// Load helpers
	["sequenceRoots", "sequenceChords", "degToMIDI", "invertMIDIChord"].do({
		arg function;
		(~path +/+ function ++ ".scd").load;
	});

	/*-------------------------------------------*/
	/*===============FUNCTION====================*/
	/*-------------------------------------------*/

	parent = ~sequenceChords.value(~sequenceRoots.value(pattern), chord_size, chord_interval);

	chordsMIDI = parent.collect({
		arg chord;
		chord.collect({
			arg degree;
			~degToMIDI.value(degree, root, scale: scale);
		});
	});

	if(
		inversions == true,
		{
			chordsMIDI.collect({
				arg chord;
				~invertMIDIChord.value(chord, scale.size, 3.rand);
			});
		},
		{
			chordsMIDI;
		}
	)
}

/*-------------------------------------------*/
/*===============IMPORTS=====================*/
/*-------------------------------------------*/
// (
// ~path = "/Users/dannysaleeb/Library/CloudStorage/Dropbox/universe/work/SuperCollider/";
//
// // Load helpers
// ["sequenceRoots", "sequenceChords", "degToMIDI", "invertChord"].do({
// 	arg function;
// 	(~path ++ "composer_functions/" ++ function ++ ".scd").load;
// });
// )
// // Create a sequence of chords based on a given pattern (takes chord_size (number of notes), and chord_interval (interval between notes), scale, inversions (boolean: do you want randomised inversions?))
// ~dnaStrand = {
// 	arg pattern=[-4,3], root=60, chord_size=3, chord_interval=3, scale, inversions=false;
// 	var parent, chordsMIDI;
//
// 	parent = ~sequenceChords.value(~sequenceRoots.value(pattern), chord_size, chord_interval);
//
// 	chordsMIDI = parent.collect({
// 		arg chord;
// 		chord.collect({
// 			arg degree;
// 			~degToMIDI.value(degree, root, scale: scale);
// 		});
// 	});
//
// 	if(
// 		inversions == true,
// 		{
// 			chordsMIDI.collect({
// 				arg chord;
// 				~invertChord.value(chord, scale.size, 3.rand);
// 			});
// 		},
// 		{
// 			chordsMIDI;
// 		}
// 	)
// }
//
//
// /*-------------------------------------------*/
// /*=================TESTS=====================*/
// /*-------------------------------------------*/
/*MIDIClient.init;
m = MIDIOut.new(0)
m.latency = 0;

(
Pbind(
	\type, \midi,
	\midiout, m,
	\chan, 0,
	\midicmd, \noteOn,
	\midinote, Pseq(~dnaStrand.value(scale: Scale.major, chord_size: 2, chord_interval: 10), 1),
	\legato, 2,
	\dur, 0.5
	).play;
)*/