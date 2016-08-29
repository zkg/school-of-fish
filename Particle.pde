//updates and draw particles
class Particle {

  PVector velocity;
  float lifespan = 25;
  PShape part;
  float partSize;
  PVector gravity = new PVector(-0.01, -1);
  float hue=0;
  
  Particle() {
    partSize = random(10, 60);
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(sprite);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, sprite.width, 0);
    part.vertex(+partSize/2, +partSize/2, sprite.width, sprite.height);
    part.vertex(-partSize/2, +partSize/2, 0, sprite.height);
    part.endShape();

    //birth ofscreen
    rebirth(width/2, height*2, 5, 0,0,0);
    lifespan = random(60,100);
  }

  PShape getShape() {
    return part;
  }

  //creates particle based on Leap data
  void rebirth(float x, float y, float z, float velX, float velY,float hueI) {
    hue = hueI+random(-15,15);
    //finding noise
    float a = random(TWO_PI);
    float randL=random(1);
    float randX= cos(a)*randL;
    float randY= sin(a)*randL;
    PVector randVel = new PVector(randX, randY); 
    float randSpeed=2;
    randVel.mult(randSpeed);

    //setting real Velocity
    float speedReal=0.02;
    velocity = new PVector(velX, velY);
    velocity.mult(speedReal);

    velocity.add(randVel);

    lifespan = random(100);
    part.resetMatrix();
    part.translate(x, y, z);
  }

  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } 
    else {
      return false;
    }
  }

  public void update() {
    lifespan = lifespan - 1;
    velocity.add(gravity);
    part.setTint(color(hue, 255, 255, lifespan));
  }
}