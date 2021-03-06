class BoidList {
  ArrayList boids;
  float h=256;

  BoidList(int n) {
    boids = new ArrayList();
    for (int i = 0; i < n; i++)
      boids.add(new Boidc(new Vec(flockWidth, flockHeight, flockDepth )));
  }

  void run() {
  
    boidkernel.flock(boids); 
    // iterate through the list of boids
    for (int i = 0; i < (range.getGlobalSize(0) * 3); i += 3) {
      Vec newpos = new Vec(boidkernel.xyz[i + 0], boidkernel.xyz[i + 1], boidkernel.xyz[i + 2]); 
      // process and make it the current boid in the list
      Boidc tempBoid = (Boidc) boids.get(i/3);
      tempBoid.hue = h;
      //update new position
      tempBoid.frame.setPosition(newpos);
      //update with new inclination
      float magic = (float) Math.sqrt(boidkernel.vxyz[i + 0]*boidkernel.vxyz[i + 0] + boidkernel.vxyz[i + 1]*boidkernel.vxyz[i + 1] + boidkernel.vxyz[i + 2]*boidkernel.vxyz[i + 2]);
      tempBoid.q = Quat.multiply(new Quat( new Vec(0,1,0),  atan2(-boidkernel.vxyz[i + 2], boidkernel.vxyz[i + 0])), new Quat( new Vec(0,0,1),  asin(boidkernel.vxyz[i + 1] / magic)) );
      // tell the temporary boid to execute its run method                      
      tempBoid.render(); 
    }
  }
}
