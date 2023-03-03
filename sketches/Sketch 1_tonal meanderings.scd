// SOME NICE PRACTICE FROM RUVIARO

(
Pbind(\degree, Pseq([0,1,2,3,4], inf), \dur, Pseq([0.25, 0.5, 0.75, 1], inf)).play;

Pbind(\degree, Pseq([0, -1, 2.1, -2, 3, -3], inf), \dur, Pseq([1, 0.75, 0.5, 0.25], inf)).play;
)