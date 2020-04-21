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

  private com.leapmotion.leap.Vector avgPos;
  private com.leapmotion.leap.Vector normalizedAvgPos;

  void onInit(com.leapmotion.leap.Controller controller) {
    // `d` is a helper method for printing debug stuff.
    d("Initialized");
    avgPos = com.leapmotion.leap.Vector.zero();
    normalizedAvgPos = com.leapmotion.leap.Vector.zero();
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
        avgPos = com.leapmotion.leap.Vector.zero();
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
