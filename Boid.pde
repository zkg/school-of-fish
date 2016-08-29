class Boid {
  InteractiveAvatarFrame frame;
  Quaternion q;
  int grabsMouseColor;
  PVector pos, vel, acc;
  float hue; 
  // scale factor for the render of the boid
  float sc = 2; 
  
  // constructors
  Boid(PVector inPos) {
    grabsMouseColor = color(0, 0, 255);		
    pos = new PVector();
    pos.set(inPos);
    frame = new InteractiveAvatarFrame(scene);	
    frame.setPosition(pos);
    frame.setAzimuth(-HALF_PI);
    frame.setTrackingDistance(scene.radius()/10);
    vel = new PVector(random(-1, 1), random(-1, 1), random(1, -1));
    acc = new PVector(0, 0, 0);
  }

  void checkBounds() {
    if (pos.x > flockWidth)
      pos.x = 0;
    if (pos.x < 0)
      pos.x = flockWidth;
    if (pos.y > flockHeight)
      pos.y = 0;
    if (pos.y < 0)
      pos.y = flockHeight;
    if (pos.z > flockDepth)
      pos.z = 0;
    if (pos.z < 0)
      pos.z = flockDepth;
  }


  void render() {

    noFill();
    noStroke();
    frame.setRotation(q);
    pushMatrix();
    // Multiply matrix to get in the frame coordinate system.	
    frame.applyTransformation();	
    scale(sc);
    //draw boid
    drawBoid3d();
    popMatrix();
  }
}



void drawBoid3d() {

  //draw boid
  beginShape(TRIANGLES);

  noFill();
  texture(textHead);

  vertex(1, 0, 0, 0, 250);
  vertex(-1, 2, 0, 250, 250);
  vertex(-1, 0, 2, 0, 0);

  vertex(1, 0, 0, 0, 250);
  vertex(-1, 2, 0, 250, 250);
  vertex(-1, 0, -2, 0, 500);

  vertex(1, 0, 0, 0, 250);
  vertex(-1, 0, 2, 0, 0);
  vertex(-1, -2, 0, 250, 250);

  vertex(1, 0, 0, 0, 250);
  vertex(-1, 0, -2, 0, 500);
  vertex(-1, -2, 0, 250, 250);

  vertex(-1, 0, 2, 250, 0);
  vertex(-10, 0, 0, 500, 250);
  vertex(-1, -2, 0, 250, 250);

  vertex(-1, 0, -2, 250, 500);
  vertex(-10, 0, 0, 500, 250);
  vertex(-1, -2, 0, 250, 250);

  vertex(-1, 0, 2, 250, 1);
  vertex(-10, 0, 0, 500, 250);
  vertex(-1, 2, 0, 250, 250);

  vertex(-1, 0, -2, 250, 500);
  vertex(-10, 0, 0, 500, 250);
  vertex(-1, 2, 0, 250, 250);

  endShape();
}

void drawBoid2d() {

  beginShape(QUADS);
  texture(textPesce);
  vertex(3, 0, 2, 0, 0);
  vertex(12, 0, 2, textPesce.width, 0);
  vertex(12, 0, 7, textPesce.width, textPesce.height);
  vertex(3, 0, 7, 0, textPesce.height);
  endShape();
}

