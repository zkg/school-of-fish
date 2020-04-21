import remixlab.proscene.*;
import remixlab.dandelion.geom.*;
import com.amd.aparapi.*;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import java.util.Date;

// amount of boids to start the program with
int initBoidNum = 6000;//1200; 
//flock bounding box
public int flockWidth = 1500;
public int flockHeight = 1050;
public int flockDepth = 750;
boolean smoothEdges = true;
boolean isDebug=false;
float hue = 200;

// background
PShape bkg;
PImage bkgImage;  
PImage textPesce;
PImage textHead;
Scene scene;
LeapMotionP5 leap;
PImage bg;
BoidList flock1;
BoidKernel boidkernel;
ParticleSystem ps;
PImage sprite;  
PVector velocity;
Range range; // kernel range

public void settings() {
    size(1600, 600, P3D);  
}

void setup() {
  smooth();
  hint(DISABLE_DEPTH_MASK);
  textureMode(IMAGE);
  scene = new Scene(this);
  //scene.setAxisIsDrawn(false);
  //scene.setGridIsDrawn(false);
  scene.setBoundingBox(new Vec(0, 0, 0), new Vec(flockWidth, flockHeight, flockDepth));
  scene.showAll();
  scene.camera().setPosition(new Vec(800, 400, 1600));
  //scene.setFrameRate(50, true);

  // create and fill the list of boids
  flock1 = new BoidList(initBoidNum); 
  this.boidkernel = new BoidKernel(flockWidth, flockHeight, flockDepth);
  //uncomment to run on CPU
  //boidkernel.setExecutionMode(Kernel.EXECUTION_MODE.CPU);
  System.out.println("Execution mode = " + boidkernel.getExecutionMode());

  //Leap initialization
  leap = new LeapMotionP5(this);

  //particle Elements
  sprite = loadImage("sprite.png");
  sprite.resize(256, 0);
  ps = new ParticleSystem(1000);

  hint(DISABLE_DEPTH_TEST); 

  // audio init
  setupAudio();

  // background init
  bkgImage = loadImage("bkg.jpg");
  textPesce = loadImage("sardine.png");
  textHead = loadImage("head.jpg");  
}

void draw() {

  //println(frameRate);
  background(#000000);
  drawBkg();   // draw background textures 
  frame.setTitle(int(frameRate) + " fps");
  pushMatrix();
  translate(0, 0, 0);
  popMatrix();
  directionalLight(100, 100, 100, 0, -1, -100);

  if (isDebug){
    noFill();
    stroke(128);

    line(0, 0, 0, 0, flockHeight, 0);
    line(0, 0, flockDepth, 0, flockHeight, flockDepth);
    line(0, 0, 0, flockWidth, 0, 0);
    line(0, 0, flockDepth, flockWidth, 0, flockDepth);

    line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
    line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
    line(0, flockHeight, 0, flockWidth, flockHeight, 0);
    line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

    line(0, 0, 0, 0, 0, flockDepth);
    line(0, flockHeight, 0, 0, flockHeight, flockDepth);
    line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
    line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);				
  }

  flock1.run();

  if (smoothEdges)
    smooth();
  else
    noSmooth(); 
    
  //automatically fade audio freq down
  if (moog.frequency.getLastValue()>20)
    moog.frequency.setLastValue(moog.frequency.getLastValue() - 20) ;  
    
  //particle emitter
  ArrayList<Finger> f = leap.getFingerList();
  int count=0;

  for (int i = 0; i < f.size();i++) {
    //audio synced with first finger
    if (i==0){    
      float freq = constrain( map( mapZforScreen(lastPos().getZ()), -350, 750, 0, 2000 ), 0, 2000 );
      float rez  = constrain( map( mapXforScreen(lastPos().getX()), width, 0, 0, .5 ), 0, .5 );
      moog.frequency.setLastValue( freq );
      moog.resonance.setLastValue( rez  );
    }

    PVector tip = leap.getTip( (Finger)f.get(i));
    //comment the following 3 lines to revert to original sparkler (multi-fingers)
    tip.x = mapXforScreen(lastPos().getX()); 
    tip.y = mapYforScreen(lastPos().getY()); 
    tip.z = mapZforScreen(lastPos().getZ()); 

    PVector vel = leap.getVelocity( (Finger)f.get(i));
    ps.setEmitter(5, tip, new PVector(-20, -20));

    fill(60, 179, 113); 
    //Draw fingers  
    stroke(60, 179, 113);
    pushMatrix();
    // Scale up by 200
    float factor = 1;
    translate(tip.x*factor, tip.y*factor, tip.z*factor);
    translate(10, 10, 10);
    popMatrix();
  }
  
  blendMode(ADD);
  ps.update();
  ps.display();
  blendMode(BLEND);
}


void keyPressed() {
  switch (key) {
  case 'u':
    smoothEdges = !smoothEdges;
    break;
  }
}

public void stop() {
  leap.stop();
}


void drawBkg(){
  
  pushMatrix();
  translate(-2000,-500,0);
  scale(2.5);
  noStroke();
  beginShape();
  texture(bkgImage);

  vertex(0,0,0,0);
  vertex(bkgImage.width,0,bkgImage.width,0);
  vertex(bkgImage.width,bkgImage.height,bkgImage.width,bkgImage.height);
  vertex(0,bkgImage.height,0,bkgImage.height);
  endShape();
  popMatrix();

}


// Track last postion as both normalized value and as raw value, and
// make note of the largests and smallest raw values so we can see 
// what range we get.
com.leapmotion.leap.Vector lastPos() {

  com.leapmotion.leap.Vector normlp = listener.normalizedAvgPos();
  com.leapmotion.leap.Vector lp = listener.avgPos();

  if (lp.getX() < xMin ){ xMin = lp.getX(); }
  if (lp.getY() < yMin ){ yMin = lp.getY(); }

  if (lp.getX() > xMax ){  xMax = lp.getX(); }
  if (lp.getY() > yMax ){  yMax = lp.getY(); }

  return normlp;
}

void d(String msg) {
  if (DEBUG) {
    println(msg);
  }
}

int mapXforScreen(float xx) {
  return( int( map(xx, 0.0, 1.0, 0.0, width-130) ) );
}

int mapYforScreen(float yy) {
  return( int( map(yy, 0.0, 1.0,  height+150, 10) ) );
}

int mapZforScreen(float zz) {
  return( int( map(zz, 0.0, 1.0,  0, 750) ) );
}

int zToColorInt(float fz) {
  // If we are getting normalized values then they
  // should always be within the the range ...
  if (fz < minZ) { return 0; }
  if (fz > maxZ) { return 255; }
  return int(map(fz, minZ, maxZ,  0, 255));
}

void writePosition(){
  int zMap = zToColorInt(lastPos().getZ());
  int baseY = mapYforScreen( lastPos().getY() );
  int inc = 30;
  int xLoc = mapXforScreen(lastPos().getX()); 

  textSize(32);
  fill(zMap, zMap, zMap);

  d("lastPos() : " + lastPos() );
  d("normalizedAvgPos  : " + normalizedAvgPos );

  text("X: " + lastPos().getX(), xLoc, baseY);
  text("Y: " + lastPos().getY(), xLoc, baseY + inc*2 );
  text("Z: " + lastPos().getZ(), xLoc, baseY + inc*3 );

  text("min X: "  + xMin, xLoc, baseY + inc*4 );
  text("max X: "  + xMax, xLoc, baseY + inc*5 );

  text("min Y: "  + yMin, xLoc, baseY + inc*6 );
  text("max Y: "  + yMax, xLoc, baseY + inc*7 );

}
