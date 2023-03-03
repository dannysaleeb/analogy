// In this file, I want to look at how morse and binary can be used to select/generate rhythmic activity.
// Instantiate morse dict
~morse = Dictionary();
~morse.putPairs([
	\a, [\dit,\dah],
	\b, [\dah,\dit,\dit,\dit],
	\c, [\dah,\dit,\dah,\dit],
	\d, [\dah,\dit,\dit],
	\e, [\dit],
	\f, [\dit,\dit,\dah,\dit],
	\g, [\dah,\dah,\dit],
	\h, [\dit,\dit,\dit,\dit],
	\i, [\dit,\dit],
	\j, [\dit,\dah,\dah,\dah],
	\k, [\dah,\dit,\dah],
	\l, [\dit,\dah,\dit,\dit],
	\m, [\dah,\dah],
	\n, [\dah,\dit],
	\o, [\dah,\dah,\dah],
	\p, [\dit,\dah,\dah,\dit],
	\q, [\dah,\dah,\dit,\dah],
	\r, [\dit,\dah,\dit],
	\s, [\dit,\dit,\dit],
	\t, [\dah],
	\u, [\dit,\dit,\dah],
	\v, [\dit,\dit,\dit,\dah],
	\w, [\dit,\dah,\dah],
	\x, [\dah,\dit,\dit,\dah],
	\y, [\dah,\dit,\dah,\dah],
	\z, [\dah,\dah,\dit,\dit]
]);

~morseToDur = {
	arg text, dit_dur_sound, dit_dur_silence=dit_dur_sound;

	// convert to symbols
	text = text.asList.collect({ arg letter; letter.asSymbol });

	text.collect({
		arg char_symbol;
		~morse[char_symbol].collect({
			arg morse_symbol, count;
			if(
				morse_symbol == \dit,
				{
					if(
						count == (~morse[char_symbol].size - 1),
						{ [dit_dur_sound, Rest(dit_dur_silence * 3)] },
						{ [dit_dur_sound, Rest(dit_dur_silence)] }
					);
				},
				{
					if(
						count == (~morse[char_symbol].size - 1),
						{ [dit_dur_sound * 3, Rest(dit_dur_silence * 3)] },
						{ [dit_dur_sound * 3, Rest(dit_dur_silence)] }
					);
				}
			);
		});
	}).flatten.flatten
};