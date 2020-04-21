//manage particles

class ParticleSystem {
  ArrayList<Particle> particles;
  PShape particleShape;
  ParticleSystem(int n) {
    particles = new ArrayList<Particle>();
    particleShape = createShape(PShape.GROUP);
    for (int i = 0; i < n; i++) {
      Particle p = new Particle();
      particles.add(p);
      particleShape.addChild(p.getShape());
    }
  }

  void update() {
    for (Particle p : particles) {
      p.update();
    }
  }
 
  //emitt particle based on Leap data
  void setEmitter(int numEmmit,PVector tip,PVector vel) {
    int count=0; 
    for (Particle p : particles) {
      if (count >= numEmmit) return; 
      if (p.isDead()) {
        p.rebirth(tip.x, tip.y, tip.z, vel.x, vel.y*8, hue);
        count++;
      }
    }  
  }
  
  void display() {
    shape(particleShape);
  }
}
