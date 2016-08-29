com.leapmotion.leap.Vector avgPos           = com.leapmotion.leap.Vector.zero();
com.leapmotion.leap.Vector normalizedAvgPos = com.leapmotion.leap.Vector.zero();

float yMax = 0;
float xMax = 0;
float yMin = 0;
float xMin = 0; 
int   minZ = 0;
int   maxZ = 1;
int   topX = 1;
int   topY = 1;
PointerListener listener = new PointerListener();
com.leapmotion.leap.Controller controller = new com.leapmotion.leap.Controller(listener);
boolean DEBUG = false;

class PointerListener extends Listener {

  private Vector avgPos;
  private Vector normalizedAvgPos;

  void onInit(com.leapmotion.leap.Controller controller) {
    // `d` is a helper method for printing debug stuff.
    d("Initialized");
    avgPos = Vector.zero();
    normalizedAvgPos = Vector.zero();
  }

  void onConnect(com.leapmotion.leap.Controller controller) {
    d("Connected");
  }

  void onFocusGained(com.leapmotion.leap.Controller controller) {
    d(" Focus gained");
  }

  void onFocusLost(com.leapmotion.leap.Controller controller) {
    d("Focus lost");
  }

  void onDisconnect(com.leapmotion.leap.Controller controller) {
    d("Disconnected");
  }

  void onFrame(com.leapmotion.leap.Controller controller) {

    com.leapmotion.leap.Frame frame = controller.frame();
    InteractionBox box = frame.interactionBox();
    HandList hands = frame.hands();

    if (hands.count() > 0 ) {
      d("Hand!");
      Hand hand = hands.get(0);
      FingerList fingers = hand.fingers();
      if (fingers.count() > 0) {
        d("Fingers!");
        avgPos = Vector.zero();
        for (Finger finger : fingers) {
          avgPos  = avgPos.plus(finger.tipPosition());
        }

        avgPos = avgPos.divide(fingers.count());
        d("avgPos x: " + avgPos.getX() );
        normalizedAvgPos = box.normalizePoint(avgPos, true);

      } 
    }
  } 

  com.leapmotion.leap.Vector avgPos(){
    return new com.leapmotion.leap.Vector(avgPos);
  }

  com.leapmotion.leap.Vector normalizedAvgPos(){
    return new com.leapmotion.leap.Vector(normalizedAvgPos);
  }
} 

// Track last postion as both normalized value and as raw value, and
// make note of the largests and smallest raw values so we can see 
// what range we get.
Vector lastPos() {

  Vector normlp = listener.normalizedAvgPos();
  Vector lp = listener.avgPos();

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