Explosion2D {

	var <numParticles, <areaWidth, <areaHeight, <particles, <vel_range, <centreX, <centreY, <asciiSpace, <text, <deadspace;

	*new {
		arg numParticles, vel_range, areaWidth, areaHeight, text=nil, deadspace=".";
		var particles, centreX, centreY, asciiSpace;

		// Define centre point of area for the explosion
		centreX = areaWidth / 2;
		centreY = areaHeight / 2;

		// Generate particles with random X and Y velocities
		if(
			text != nil,
			{
				numParticles.do({
					particles = particles.add(Particle.new(vel_range, text[text.size.rand]))
				})
			},
			{
				numParticles.do({
					particles = particles.add(Particle.new(vel_range))
				})
			}
		);
		// Create the ascii representation of the space
		areaHeight.do({
			asciiSpace = asciiSpace.add(List.fill(areaWidth, { deadspace }))
		});

        ^super.newCopyArgs(numParticles, areaWidth, areaHeight, particles, vel_range, centreX, centreY, asciiSpace, text, deadspace)
    }

	advanceFrames {
		arg numFrames;
		this.particles.do({
			arg particle;
			particle.advanceFrames(numFrames)
		});
	}

	rewindFrames {
		arg numFrames;
		this.particles.do({
			arg particle;
			particle.rewindFrames(numFrames)
		});
	}

	reset {
		this.particles.do({
			arg particle;
			particle.reset
		})
	}

	drawFrame {
		// Clear asciiSpace
		this.asciiSpace.do({
			arg row;
			row.size.do({
				arg i;
				row.put(i, deadspace)
			})
		});

		// draw the particles in the correct positions
		particles.do({
			arg particle;
			var yCoord, xCoord;

			yCoord = particle.y + this.centreY;
			xCoord = particle.x + this.centreX;

			if(
				this.asciiSpace[yCoord] != nil,
				{
					if(
						this.asciiSpace[yCoord][xCoord] != nil,
						{
							this.asciiSpace[yCoord].put(xCoord, particle.char)
						}
					)
				}
			)
		});

		this.asciiSpace.do({
			arg row;
			var string="";
			row.do({
				arg item;
				string = string + item
			});
			string.postln
		})
	}

	drawFrame2File {
		arg outputDir, filename;
		var file;

		file = File.new(outputDir ++ filename, "w");

		this.asciiSpace.do({
			arg row;
			var string = "";
			row.do({
				arg item;
				string = string + item
			});
			string = string ++ "\n";
			file.write(string);
		});

		file.close
	}

	goToFrame {
		arg numFrames;

		this.particles.do({
			arg particle;
			particle.reset
		});

		this.particles.do({
			arg particle;
			particle.advanceFrames(numFrames)
		})
	}

	getParticleDistances {
		// Make it possible to get distance from particle in previous frame to current frame (default is from origin)
		arg start_frame=0;
		var vec_magnitudes;

		this.particles.do({
			arg particle;

			if(
				particle.isNegative == true,
				{
					vec_magnitudes = vec_magnitudes.add(
				(particle.x.pow(2) + particle.y.pow(2)).sqrt.neg)
				},
				{
					vec_magnitudes = vec_magnitudes.add(
						(particle.x.pow(2) + particle.y.pow(2)).sqrt)
				}
			);
		});

		^vec_magnitudes.sort
	}

	getTickDistances {
		arg tick_duration;

		^this.getParticleDistances.collect({
			arg particle_dist;
			(particle_dist.round * tick_duration)
		})
	}

	getDurationDistances {
		arg tick_duration;
		var tick_distances;

		tick_distances = this.getTickDistances(tick_duration);

		^tick_distances = tick_distances.sort;

	}

	getDurations {
		arg tick_duration;
		var dur_distances, durations;

		dur_distances = this.getDurationDistances(tick_duration).as(Set).as(Array).sort;

		dur_distances.size.do({
			arg i;
			durations = durations.add(
				if(
					(i+1) < dur_distances.size,
					{
						(dur_distances[i+1] - dur_distances[i]).abs
					}
				)
			)
		});

		^durations
	}

	/*getParticleDistances {
		arg particle, numSteps, stepSize=1, constant=0.75;
		var particleData=Dictionary.new(), x_coord=(particle[\x] - this.centreX), y_coord=(particle[\y] - this.centreY);

		numSteps.do({
			arg i;
			if(i>0,{this.advanceFrames(1)});
			particleData.put(i, Dictionary.newFrom([\dist, (x_coord.pow(2) + y_coord.pow(2)).sqrt, \amp, 1 * 0.75.pow(i)]))
		});
		^particleData
	}*/
}



// Ok ... now I can advance any number of frames and get the frame data ... need to go through and get the x coords, and apply that to positions in time ... so durations as a pattern of durations ... if there's a o, then onset, otherwise, rests.

// Actually playing these will be interesting ... perhaps 1 piano will play one frame, and the other will play another (on top of each other, or very slightly apart) -- think about the implications of playing them with an offset ... what does that represent? It's like an overlapping animation ... where the frames aren't distinct anymore, instead, blurred ... overlapping.

// y coords will be more difficult -- need to map to pitches ... depends how many particles there are in a given asciiSpace ... divide the asciiSpace up into "pitch asciiSpace" according to how many tones there are in a chord; then check which pitch asciiSpace the particles are in, and reserve certain asciiSpace for corporeal pitches ... maybe ... or something like that.

// 1. create method for mapping coords to durations
// 2. create method for mapping choords to pitch
