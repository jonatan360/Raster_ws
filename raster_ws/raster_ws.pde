import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3, p, temp;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// Antialiasing
int antialiasing = 2;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(512, 512, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  pushStyle();
  noStroke();
  fill(255, 255, 0, 125);
  
  int potencia = (int)Math.pow(2, n-1);
  for(int i = - potencia; i <= potencia; i++){
    for(int j = - potencia; j <= potencia; j++){
      setColor(i, j, getIntensity(i, j));
      rect(i, j, 1, 1);
    }
  }
  popStyle();
}


int getIntensity(int a, int b) {
  float pixel_witdh = 1/(antialiasing * 1.0);
  int inside = 0;
  for(int i = 0; i < antialiasing ; i++){
    for(int j = 0; j < antialiasing ; j++){
      float x_a = a + pixel_witdh * i;
      float y_a = b + pixel_witdh * j;
      if( insideT(x_a, y_a) ) {
        inside += 1;
      }
    }
  }
  
  int intensity = Math.round(255*(inside/(1.0 * antialiasing * antialiasing)));
  return intensity;
}

void setColor(float x , float y, int intensity) {
  float v1_x = frame.coordinatesOf(v1).x();
  float v2_x = frame.coordinatesOf(v2).x();
  float v3_x = frame.coordinatesOf(v3).x();
  
  float v1_y = frame.coordinatesOf(v1).y(); 
  float v2_y = frame.coordinatesOf(v2).y();  
  float v3_y = frame.coordinatesOf(v3).y();
   
  float t1 = abs(((v2_x - v1_x) * (y - v1_y)) - ((x - v1_x) * (v2_y - v1_y)));
  float t2 = abs(((v3_x - v2_x) * (y - v2_y)) - ((x - v2_x) * (v3_y - v2_y)));
  float t3 = abs(((v1_x - v3_x) * (y - v3_y)) - ((x - v3_x) * (v1_y - v3_y)));
      
  
  float m = t1+t2+t3/ (antialiasing * antialiasing);  
  fill(255*(t1/m), 255*(t2/m), 255*(t3/m), intensity);
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  
  if((v1.y()-v2.y())*v3.x()+
     (v2.x()-v1.x())*v3.y()+
     (v1.x()*v2.y()-v1.y()*v2.x())<=0){
       temp = v1;
       v1 = v3;
       v3 = temp;
  }
}

boolean insideT(float x , float y) {
  float v1_x = frame.coordinatesOf(v1).x();
  float v2_x = frame.coordinatesOf(v2).x();
  float v3_x = frame.coordinatesOf(v3).x();
  
  float v1_y = frame.coordinatesOf(v1).y(); 
  float v2_y = frame.coordinatesOf(v2).y();    
  float v3_y = frame.coordinatesOf(v3).y();
         
  float t1 = ((v2_x - v1_x) * (y - v1_y)) - ((x - v1_x) * (v2_y - v1_y));
  float t2 = ((v3_x - v2_x) * (y - v2_y)) - ((x - v2_x) * (v3_y - v2_y));
  float t3 = ((v1_x - v3_x) * (y - v3_y)) - ((x - v3_x) * (v1_y - v3_y));
  return (t2>0 && t3>0 && t1>0);
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}