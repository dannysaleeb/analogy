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

// Converts a string to binary numbers representing morse code
// Each dit gives [1, 0], and each dah [1, 1, 1, 0].
// Can be used for selecting chords in a sequence etc.
~morseWordToBinary = {
	arg word;

	// convert to symbols
	word = word.asList.collect({ arg letter; letter.asSymbol });

	word.collect({
		arg name_symbol;
		~morse[name_symbol].collect({
			arg morse_symbol, count;
			if(
				morse_symbol == \dit,
				{
					if(
						count == (~morse[name_symbol].size - 1),
						{ [1, 0, 0, 0] },
						{ [1, 0] }
					);
				},
				{
					if(
						count == (~morse[name_symbol].size - 1),
						{ [1, 1, 1, 0, 0, 0] },
						{ [1, 1, 1, 0] }
					);
				}
			);
		});
	}).flatten.flatten
}