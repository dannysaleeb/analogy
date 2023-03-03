(
/*-------------------------------------------*/
/*================LOAD=======================*/
/*-------------------------------------------*/
~path = thisProcess.nowExecutingPath.dirname;

// Load helpers
["morseWordToBinary", "asciiToBinary"].do({
	arg function;
	(~path +/+ function ++ ".scd").load;
})
);

~binSelect = {
	arg text, sequence, offset=0, all=true, mode="bin";
	var bin, return_list;

	if( text.class == String, { text = text.toLower } );

	if(
		mode == "ascii",
		{ bin = ~asciiToBinary.value(text).postln },
		{
			if( mode == "morse", { bin = ~morseWordToBinary.value(text).postln }, { bin = text });
		}
	);

	return_list = bin.flatten.collect({
		arg bit, count;
		if(
			bit == 1,
			{ sequence[count + offset % sequence.size] },
			{ 0 }
		)
	});

	return_list.postln;

	return_list;
}