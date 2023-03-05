# SUPERCOLLIDER EXPERIMENTS & COMPOSITION PROJECTS

## [you, me].lace (eight hands at two pianos) - in analogy/youmelace

I've used this piece as a means of training myself how to work with SuperCollider as a compositional aid, and to start to create a workflow and compositional process as a basis for more complex algorithmic experiments later in the project. 

The conceptual analogy that drives the process was taken from a number sequence in "Fluid Concepts and Creative Analogies" by Douglas Hofstadter and the Fluid Analogies Research Group, which was constructed by interleaving three separate "sibling" sequences to create a more complex "parent" sequence. This gave rise to a process of algorithmically generating simple harmonic sequences (using the function dnaStrand from supercollider/composer_functions, which builds on the functions sequenceRoots and sequenceChords) which would then be interleaved, and interleaved again with other sequences using SuperCollider's .lace method. I gave the chords a rhythmic profile, by using binary data to select chords that play and chords that don't. The binary data was generated by using related text (as a string) converted to morse code using the function binSelect (supercollider/composer_functions/binSelect.scd), and later using an extension to SuperCollider's String class, .morse2bin (in supercollider/extensions/StringExtensions.scd).

The piece is in progress, but I have arranged some of the "me" movement (me.scd in analogy/youmelace/scd), which will later form part of a final "[you, me].lace" movement. I have tried to extend the concept of interleaving to the way that the material is distributed across two pianos, and also to the way the two musicians at each piano cross hands and become physically interleaved. 

* Some audio extracts can be found in analogy/youmelace/audio
* The current pdf score for workshop is "analogy/youmelace/Piano Ensemble Sketches 1.pdf"
* A short video of work in progress live [here](https://www.dropbox.com/s/wzur3x6dksiuysp/Improvising%20with%20ME_2023-01-31%20at%2017.02.38.mov?dl=0)

## everyone is covered in flowers (two tenor viols) - in analogy/viols

I am using this short piece as an opportunity to experiment with incorporating the results of statistical analysis of existing music into the process of generating material for my own music, and in this case a simple Markov Chain. I hope this lays the foundation for more complex experiments that allow me to formalise analogy-making between existing music and new.

In this case I took a single imitative piece for two viols ("Que todos sepassan en flores", Cantoniero de Uppsala 1556) as a model to analyse, sliced it into quaver-sized slices, then recorded the pitch interval between parts for every slice (recording \none where nothing was playing, and \solo where only a single instrument was playing, otherwise a pitch interval). I then used this information to record, for each unique pitch interval in the piece, the pitch interval in the succeeding slice, and then used this information to build a probability model for generating a new chain of pitch intervals.

I have not yet applied this such that specific pitches are generated, as I felt that this was a more challenging task. Instead, I used the chain of pitch intervals as a slightly fluid constraint for creating a number of simple phrases related (intuitively) to the original model. 

The piece is entitled "everyone is covered in flowers" after an exchange with ChatGPT:

<div align='center'>

**DS**:         
what does "que todos sepassan en flores" mean?

**ChatGPT**:    
The phrase "que todos se pasan en flores" is not a standard expression in Spanish, and it does not have a clear or direct translation into English.

It is possible that this phrase was intended to mean "that everyone is covered in flowers" or "that everyone is immersed in flowers". However, without more context or information about the origin of the phrase, it's difficult to determine the intended meaning with certainty.

If you can provide more context or information about the origin of the phrase, I may be able to provide a more accurate interpretation.

**DS**:         
It is the title of an imitative piece of music for two viols

**ChatGPT**:    
Ah, in that case, "Que todos se pasan en flores" could be translated as "May everyone revel in flowers."

As a title of a piece of music, it is not necessarily meant to have a direct and literal meaning, but rather to evoke a particular mood or feeling that the composer wants to convey through the music.

In this case, the phrase suggests a joyful, festive atmosphere, with everyone surrounded by and celebrating with flowers. The music may be intended to capture this sense of celebration and joy.

</div>

* The continuation of the piece will explore ornamentation, inspired by the given title.
* Examples of the generated chains of pitch intervals can be found in analogy/viols/output
* The notated music in progress can be found in "analogy/viols/pdf/everyone is covered in flowers - Full Score.pdf"
* The code is found in "analogy/viols/scd/VDG Duets.scd"