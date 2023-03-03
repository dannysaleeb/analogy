+ SimpleNumber {

    tempo2beat {
		// Gets something
		var tempo=this, beatdur;
		beatdur = 60 / tempo;
		^beatdur
    }

	beatdur2secs {
		arg tempo;
		var notedur;
		notedur = this;
		^this * (60 / tempo)
	}

}

