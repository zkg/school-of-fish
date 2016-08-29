public class BoidKernel extends Kernel{
  
  // maximum magnitude of the steering vector
  float maxSteerForce = .08f; 
  float neighborhoodRadius = 120f;
  float strengthWalls = 45f;
  //attraction/repulsion strength: 100f = repulsion; -100f = attraction
  float strengthFingers = -100f;
  // maximum magnitude for the velocity vector
  float maxSpeed = 4f; 
  float avoidWalls = 1;
  
   // radius in which it looks for fellow boids
  int flockHeight;
  int flockWidth;
  int flockDepth;
  
  PVector ali, coh, sep, pos, vel, acc;
  float posx;
  float posy;
  float posz;
  float[] handx;
  float[] handy;
  float[] handz;
  float[] fingerx;
  float[] fingery;
  float[] fingerz;
  int handsize = 0;
  int fingersize = 0;
  public float[] xyz; // positions xy and z of bodies
  public float[] vxyz; // velocity component of x,y and z of bodies
  public float[] axyz; //acc
  public float[] cxyz; //coe
  
  public BoidKernel(int flockHeight, int flockWidth, int flockDepth) {
    this.flockHeight = flockHeight;
    this.flockWidth = flockWidth;
    this.flockDepth = flockDepth;
    range = Range.create(initBoidNum);
    xyz = new float[range.getGlobalSize(0) * 3];
    vxyz = new float[range.getGlobalSize(0) * 3];
    axyz = new float[range.getGlobalSize(0) * 3];
    cxyz = new float[range.getGlobalSize(0) * 3];
    handx = new float[1];
    handy = new float[1];
    handz = new float[1];
    fingerx = new float[1];
    fingery = new float[1];
    fingerz = new float[1];

    for (int body = 0; body < (range.getGlobalSize(0) * 3); body += 3) {
          // initialize the 3D dimensional coordinates to something interesting
          xyz[body + 0] = (float) flockWidth/1f;
          xyz[body + 1] = (float) flockHeight/8f;
          xyz[body + 2] = (float) flockDepth/2f;

          vxyz[body + 0] = (float) random(-1f, 1f);
          vxyz[body + 1] = (float) random(-1f, 1f);
          vxyz[body + 2] = (float) random(-1f, 1f);
          
          axyz[body + 0] = 0f;
          axyz[body + 1] = 0f;
          axyz[body + 2] = 0f;
          
          cxyz[body + 0] = 0f;
          cxyz[body + 1] = 0f;
          cxyz[body + 2] = 0f;
          
    }
   setExplicit(true);
  }

   
  @Override
  public void run() {
    
     final int body = getGlobalId();
     //getglobalside(0) is the amount of boids
     final int count = getGlobalSize(0) * 3;
     final int globalId = body * 3;   
     float result = 0.f;
     float posSumx = 0.f;
     float posSumy = 0.f;
     float posSumz = 0.f;
     float steerx = 0.f;
     float steery = 0.f;
     float steerz = 0.f;
     int i;
     float avox = 0.f;
     float avoy = 0.f;
     float avoz = 0.f;
              
      //avoid walls
      
      if (avoidWalls == 1){
        avox = (float)avoid(xyz[globalId + 0], 0, xyz[globalId + 2], 1, 0, result)*strengthWalls;
        avoy = (float)avoid(xyz[globalId + 0], 0, xyz[globalId + 2], 1, 1, result)*strengthWalls;
        avoz = (float)avoid(xyz[globalId + 0], 0, xyz[globalId + 2], 1, 2, result)*strengthWalls;
        axyz[globalId + 0] += avox;
        axyz[globalId + 1] += avoy;
        axyz[globalId + 2] += avoz;

        avox = (float)avoid(0, xyz[globalId + 1], xyz[globalId + 2], 1, 0, result)*strengthWalls;
        avoy = (float)avoid(0, xyz[globalId + 1], xyz[globalId + 2], 1, 1, result)*strengthWalls;
        avoz = (float)avoid(0, xyz[globalId + 1], xyz[globalId + 2], 1, 2, result)*strengthWalls;
        axyz[globalId + 0] += avox;
        axyz[globalId + 1] += avoy;
        axyz[globalId + 2] += avoz;
        
        avox = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], 0, 1, 0, result)*strengthWalls;
        avoy = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], 0, 1, 1, result)*strengthWalls;
        avoz = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], 0, 1, 2, result)*strengthWalls;
        axyz[globalId + 0] += avox;
        axyz[globalId + 1] += avoy;
        axyz[globalId + 2] += avoz; 
        
        avox = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], (float)flockDepth, 1, 0, result)*strengthWalls;
        avoy = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], (float)flockDepth, 1, 1, result)*strengthWalls;
        avoz = (float)avoid(xyz[globalId + 0], xyz[globalId + 1], (float)flockDepth, 1, 2, result)*strengthWalls;
        axyz[globalId + 0] += avox;
        axyz[globalId + 1] += avoy;
        axyz[globalId + 2] += avoz; 
      }
     
      
      
      
      //avoid hands/fingers!
      for (i=0; i < handsize; i++){
          avox = (float)avoid(handx[i], handy[i], handz[i], 1, 0, result)*strengthFingers;
          avoy = (float)avoid(handx[i], handy[i], handz[i], 1, 1, result)*strengthFingers;
          avoz = (float)avoid(handx[i], handy[i], handz[i], 1, 2, result)*strengthFingers;
          axyz[globalId + 0] += avox;
          axyz[globalId + 1] += avoy;
          axyz[globalId + 2] += avoz;          
      }
      
      for (i=0; i < fingersize; i++){
          avox = (float)avoid(fingerx[i], fingery[i], fingerz[i], 1, 0, result)*strengthFingers;
          avoy = (float)avoid(fingerx[i], fingery[i], fingerz[i], 1, 1, result)*strengthFingers;
          avoz = (float)avoid(fingerx[i], fingery[i], fingerz[i], 1, 2, result)*strengthFingers;
          axyz[globalId + 0] += avox;
          axyz[globalId + 1] += avoy;
          axyz[globalId + 2] += avoz;          
      }
      
      
      //alignment
      float velSumx = 0f; 
      float velSumy = 0f;
      float velSumz = 0f;
      int counta = 0;
     
      float posx = xyz[globalId + 0];
      float posy = xyz[globalId + 1];
      float posz = xyz[globalId + 2];
      
       for (i = 0; i < count; i += 3) {
          if (dist(xyz[globalId + 0],  xyz[globalId + 1], xyz[globalId + 2], xyz[i + 0], xyz[i + 1], xyz[i + 2]) > 0f && dist(xyz[globalId + 0],  xyz[globalId + 1], xyz[globalId + 2], xyz[i + 0], xyz[i + 1], xyz[i + 2]) <= neighborhoodRadius) {
            velSumx += vxyz[i + 0];
            velSumy += vxyz[i + 1];
            velSumz += vxyz[i + 2];
            counta++;
          }
       }
       
    if (counta > 0) {
      velSumx /= (float) counta;
      velSumy /= (float) counta;
      velSumz /= (float) counta;
      velSumx = limit(velSumx, velSumy, velSumz, maxSteerForce, 0, result);
      velSumy = limit(velSumx, velSumy, velSumz, maxSteerForce, 1, result);
      velSumz = limit(velSumx, velSumy, velSumz, maxSteerForce, 2, result);
    }

    axyz[globalId + 0] += velSumx;
    axyz[globalId + 1] += velSumy;
    axyz[globalId + 2] += velSumz;
     //end alignment
     
   //cohesion
   counta = 0;
   for (i = 0; i < count; i += 3) {
        float bposx =  xyz[i + 0];
        float bposy =  xyz[i + 1];
        float bposz =  xyz[i + 2];
        
        float bvelx = vxyz[i + 0];
        float bvely = vxyz[i + 1];
        float bvelz = vxyz[i + 2];
        
        float d = dist2(posx, bposx, posy, bposy);  
        if (d > 0f && d <= neighborhoodRadius) {      
          posSumx += bposx;
          posSumy += bposy;
          posSumz += bposz;
          
          counta++;
        }

     }
     
     if (counta > 0) {
      posSumx /= counta;
      posSumy /= counta;
      posSumz /= counta;
    }
    
    steerx = posSumx - posx;
    steery = posSumy - posy;
    steerz = posSumz - posz;
    steerx = limit(steerx, steery, steerz, maxSteerForce, 0, result);
    steery = limit(steerx, steery, steerz, maxSteerForce, 1, result);
    steerz = limit(steerx, steery, steerz, maxSteerForce, 2, result);
   
    axyz[globalId + 0] += steerx*3f;
    axyz[globalId + 1] += steery*3f; 
    axyz[globalId + 2] += steerz*3f;
     //end cohesion
     
     //separation
     posSumx = 0f;
     posSumy = 0f;
     posSumz = 0f;
     float repulsex;
     float repulsey;
     float repulsez;
      
    for (i = 0; i < count; i += 3) {
        steerx = dist(posx,posy,posz, xyz[i + 0], xyz[i + 1], xyz[i + 2]);
        if (steerx > 0f && steerx <= neighborhoodRadius) {      
          posSumx = posSumx + (normalize(posx - xyz[i + 0], posy - xyz[i + 1], posz - xyz[i + 2], 0, result) / steerx);
          posSumy = posSumy + (normalize(posx - xyz[i + 0], posy - xyz[i + 1], posz - xyz[i + 2], 1, result) / steerx);
          posSumz = posSumz + (normalize(posx - xyz[i + 0], posy - xyz[i + 1], posz - xyz[i + 2], 2, result) / steerx);
        }
     } 
      axyz[globalId + 0] += posSumx;
      axyz[globalId + 1] += posSumy; 
      axyz[globalId + 2] += posSumz;
     
     //end separation
    
    // add acceleration to velocity
    vxyz[globalId + 0] += axyz[globalId + 0];
    vxyz[globalId + 1] += axyz[globalId + 1];
    vxyz[globalId + 2] += axyz[globalId + 2];
    
    // make sure the velocity vector magnitude does not exceed maxSpeed
    vxyz[globalId + 0] = limit(vxyz[globalId + 0], vxyz[globalId + 1], vxyz[globalId + 2], maxSpeed, 0, result);
    vxyz[globalId + 1] = limit(vxyz[globalId + 0], vxyz[globalId + 1], vxyz[globalId + 2], maxSpeed, 1, result);
    vxyz[globalId + 2] = limit(vxyz[globalId + 0], vxyz[globalId + 1], vxyz[globalId + 2], maxSpeed, 2, result);
    
    // add velocity to position         
    xyz[globalId + 0] += vxyz[globalId + 0];
    xyz[globalId + 1] += vxyz[globalId + 1]; 
    xyz[globalId + 2] += vxyz[globalId + 2];    
    
    // reset acceleration
    axyz[globalId + 0] *= 0f;
    axyz[globalId + 1] *= 0f;
    axyz[globalId + 2] *= 0f;
    
    //invert velocity if element is gone too far
    if (xyz[globalId + 0] > flockWidth*2){
          vxyz[globalId + 0] *= -1;
          xyz[globalId + 0] = flockWidth*2;
    }
    
    
    if (xyz[globalId + 0] < 0){
          vxyz[globalId + 0] *= -1;
          xyz[globalId + 0] = 0;
    }       
    
   if (xyz[globalId + 1] > flockHeight/2 ){
          vxyz[globalId + 1] *= -1;                
          xyz[globalId + 1] = flockHeight/2;      
    }
    
    if (xyz[globalId + 1] < 0){
          vxyz[globalId + 1] *= -1;
          xyz[globalId + 1] = 0;
    }
    
    if (xyz[globalId + 2] > flockDepth*1){
          vxyz[globalId + 2] *= -1;    
          xyz[globalId + 2]  = flockDepth*1;
    }
    
    if ( xyz[globalId + 2] < 0){
          vxyz[globalId + 2] *= -1;  
          xyz[globalId + 2] = 0;
    }
  }
    
  //behaviors
  void flock(ArrayList bl) {
        //xyz = coords in bl
         
        ArrayList<Finger> fingerList = leap.getFingerList();
        fingersize = fingerList.size();
        if (fingersize>0){
         
          fingerx = new float[fingersize];
          fingery = new float[fingersize];
          fingerz = new float[fingersize];
          int i = 0;

        //handle too many fingers (two hands)
        for (Finger finger : fingerList) {
           PVector fingerPos = leap.getTip(finger);
            fingerx[i] = fingerPos.x;
            fingery[i] = fingerPos.y;
            fingerz[i] = fingerPos.z;
            i++;
          }
        }
       
    execute(range);
    if (this.isExplicit()) {
       this.get(this.xyz);
       this.get(this.vxyz);
    }
  }
  
  
  public float dist(float v1x, float v1y, float v1z, float v2x, float v2y, float v2z) {
    float dx = v1x - v2x;
    float dy = v1y - v2y;
    float dz = v1z - v2z;
    float res = (float)sqrt(dx*dx + dy*dy + dz*dz);
    return res;
  }
  
  
  public float dist2(float posx, float bposx, float posy, float bposy ){
    return (float)sqrt((posx - bposx) * (posx - bposx) + (posy - bposy) * (posy - bposy));   
  }
  
  
  public float limit(float x, float y, float z, float max, int coord, float result) {
    if ((x*x + y*y + z*z) > max*max) {
         float m = (float)sqrt(x*x + y*y + z*z);
          if (m != 0f && m != 1f) {
            x /= m;
            y /= m;
            z /= m;     
          }
        x *= max;
        y *= max;
        z *= max;
    }
       
    if (coord==0)
      result = x;
    if (coord==1)
      result = y;
    if (coord==2)
      result = z;
    
    return result;
    
  }
  
  public float magnitudo(float x, float y, float z){
    float mag = (float) sqrt(x*x + y*y + z*z);
    return mag;
  }
  
  
  public float normalize(float x, float y, float z, int coord, float result) {
    
    
    float m = magnitudo(x, y, z);
    
    if (m != 0f && m != 1f) {
      x /= m;
      y /= m;
      z /= m;
    }
    if (coord == 0)
      result = x;
    if (coord == 1)
      result = y;
    if (coord == 2)
      result = z;
    
    return result;
  }
  

  public float avoid(float targetx, float targety, float targetz, int weight, int coord, float result){

    float steerx = xyz[getGlobalId()] - targetx;
    float steery = xyz[getGlobalId()+1] - targety;
    float steerz = xyz[getGlobalId()+2] - targetz;
    float n=0.f;
    
    if (weight == 1){
      float d = dist(xyz[getGlobalId()], xyz[getGlobalId()+1], xyz[getGlobalId()+2], targetx, targety, targetz);
      steerx *= 1.0f / (d*d);
      steery *= 1.0f / (d*d);
      steerz *= 1.0f / (d*d);
    }
      
    if (coord==0)
      result = steerx;
    if (coord==1)
      result = steery;
    if (coord==2)
      result = steerz;

    return result;
    
  }
    
}
