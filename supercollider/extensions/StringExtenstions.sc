Morse {
	classvar <morsedict;

	*initClass {
		morsedict = {
			|dict|
			dict = Dictionary.new();
			dict.putPairs([
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
			])
		}.value;
	}

	getmorsedict {
		^morsedict;
	}
}


+ String {

	ascii2bin {
		var return = [];
		this.do({
			arg char;
			return = return.add(char.ascii.asBinaryDigits);
		});
		^return.flatten
	}

	morse2bin {

		var morse=Morse.morsedict, word, returnlist;

		// convert to symbols
		word = this.toLower.asList.collect({ arg letter; letter.asSymbol });

		returnlist = word.collect({
			arg name_symbol;
			if(
				name_symbol == ' ',
				{ [0, 0, 0, 0] },
				{
					morse[name_symbol].collect({
						arg morse_symbol, count;
						if(
							morse_symbol == \dit,
							{
								if(
									count == (morse[name_symbol].size - 1),
									{ [1, 0, 0, 0] },
									{ [1, 0] }
								);
							},
							{
								if(
									count == (morse[name_symbol].size - 1),
									{ [1, 1, 1, 0, 0, 0] },
									{ [1, 1, 1, 0] }
								);
							}
						);
					});
				}
			)
		});
		returnlist = returnlist.add([0, 0, 0, 0]);
		^returnlist.flatten.flatten
	}

	morse2dur {

		arg dit_dur_on, dit_dur_off=dit_dur_on;
		var text, morse=Morse.morsedict, returnlist;

		// convert to symbols
		text = this.toLower.asList.collect({ arg letter; letter.asSymbol });

		returnlist = text.collect({
			arg char_symbol;
			morse[char_symbol].collect({
				arg morse_symbol, count;
				if(
					morse_symbol == \dit,
					{
						if(
							count == (morse[char_symbol].size - 1),
							{ [dit_dur_on, Rest(dit_dur_off * 3)] },
							{ [dit_dur_on, Rest(dit_dur_off)] }
						);
					},
					{
						if(
							count == (morse[char_symbol].size - 1),
							{ [dit_dur_on * 3, Rest(dit_dur_off * 3)] },
							{ [dit_dur_on * 3, Rest(dit_dur_off)] }
						);
					}
				);
			});
		});
		returnlist = returnlist.add(Rest(dit_dur_off * 4));
		^returnlist.flatten.flatten
	}
}

