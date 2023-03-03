// Takes two Lists of somethings and zeroes (me and you), and fills in the zeroes in me where there is something in equivalent position in you.

// First needs to get a number that is the product of the size of both, right?
~completeMe = {

	arg me, you;
	var youme, size;

	size = me.size * you.size;

	youme = size.collect({
		arg i;
		if(
			me[i % me.size] == 0,
			{
				if(
					you[i % you.size] != 0,
					{ you[i % you.size] },
					{ me[i % me.size ]}
				)
			},
			{ me[i % me.size] }
		);
	});

}

// OOh ... this is clever, because it's fragments of the same sequence ... and interleaving ... woah. cool.
~bop = ~completeMe.value([ 0, [ 60, 76 ], [ 60, 67, 75, 82 ], 0, 0], [0, 0, [ 57, 72 ], [ 55, 63, 70, 77 ], 0, 0]);

~moop = ~completeMe.value(~plip, ~plop);

~plip = ~binSelect.value("danny", o, mode: "ascii");
~plop = ~binSelect.value("kitty", z, mode: "ascii");
z;