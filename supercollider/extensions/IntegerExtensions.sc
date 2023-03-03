+ Integer {

	midi2deg {
		arg midival, scale=Scale.major;

		if (
			midival > 0 && midival <= 127,
			{
				^scale.degrees.indexOf((midival - this) % scale.stepsPerOctave.asInteger)
			},
			{ nil }
		)

	}

}