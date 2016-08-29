# school-of-fish
Processing app that simulates a school of fish using OpenCL (Aparapi) and allows users to interact via a Leap Motion controller.

Originally conceived for an installation, this code can be adapted to new projects with some adjustments. The sketch was written for Linux machines with a GPU. An old 92 cores gpu is capable of running a thousand boids at 40fps.

[![School of fish](http://www.jamez.it/dropbox/school_of_fish.png)](https://vimeo.com/160390814 "School of fish")

##Installation

Simply clone and run with Processing 2.1. Processing 3 won't work out of the box since it brought major changes. These changes require to adapt calls to minim and proscene libraries (and possibly other things).

##Dependencies

* Processing 2.1

* Minim 

* Proscene

* Leap Motion Controller (though the sketch could easily run without)

* A GPU (though the sketch could run much slower on the CPU)


##Acknowledgements

Bruno capezzuoli for most of the graphics; Matthew Wetmore for the boid algorithm this release is inspired on; Gary Frost for the Aparapi library.
