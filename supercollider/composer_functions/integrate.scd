// Need an algorithm to gradually integrate one chord sequence into another ... but how?

// Basically just take a duration, and exponentially integrate them into each other.

// Given a list of 1s and a list of 0s, how often should the 1s and 0s swap places?

a = List.fill(100, { 0 });
b = List.fill(100, { 1 });

a;
b;

~integrate = {
	arg one, two, exponent=0.8;
	var returnlist;

	one.size.collect({
		arg num;
		one.size * exponent.pow(num)
	})
}

// Not quite sure what I'm trying to do here yet! Exponential integration ... I guess.
// maybe towards totally even interleaving of parts at a suitable point (GS...?)
~exp_positions = (~integrate.value(a, b, 0.9).sort.reverse - a.size).abs.round.asInteger;

(
var mylist;

(
~exp_positions.do({
	arg i;
	if(i < a.size,
		{a.put(i, 1)}
	);
	a.put(0, 0);
});
a
)

)

a;