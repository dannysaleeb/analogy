Particle {
	var <>x, <>y, <velX, <velY, <char;

	*new {
		arg vel_range, char="o";
		var x, y, velX, velY;

		x = 0;
		y = 0;

		velX = vel_range.rand - (vel_range / 2);
		velY = vel_range.rand - (vel_range / 2);

        ^super.newCopyArgs(x, y, velX, velY, char)
    }

	advanceFrames {
		arg numFrames;

		this.x = (this.x + (velX * numFrames)).asInteger;
		this.y = (this.y + (velY * numFrames)).asInteger
	}

	rewindFrames {
		arg numFrames;

		if(
			this.x == 0 && this.y == 0,
			{
				nil
			},
			{
				this.x = (this.x - (velX * numFrames)).asInteger;
				this.y = (this.y - (velY * numFrames)).asInteger
			}
		)
	}

	reset {
		this.x = 0;
		this.y = 0
	}

	getCoords {
		^[this.x, this.y]
	}

	getMagnitude {
		^(this.x.pow(2) + this.y.pow(2)).sqrt
	}

	isNegative {
		^this.x.isNegative
	}

	isPositive {
		^this.x.isPositive
	}

}