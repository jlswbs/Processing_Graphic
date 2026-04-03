// Noise zoomed tiles pattern //

int WIDTH = 960;
int HEIGHT = 540;

PImage framebuffer;

float t = 0;
float baseZoom = 0.01;

boolean saving = false;
int frameCounter = 0;
String saveDir = "frames";

void setup() {
  
  size(100, 100, P2D);
  surface.setSize(WIDTH, HEIGHT);
  
  framebuffer = createImage(WIDTH, HEIGHT, ARGB);
  noSmooth();
  
  background(0);
  frameRate(60);
  
  t = 0;

}

void draw() {
  
  framebuffer.loadPixels();
  
  t = t + 0.02;

  float dynamicZoom = baseZoom + (sin(t * 0.5) * 0.003);

  for (int x = 0; x < width; x++) {
    
    for (int y = 0; y < height; y++) {
      
      float n = random(0.0, 0.05);

      float fx = (x * dynamicZoom) + n + t;
      float fy = (y * dynamicZoom) + n - t;

      float a = fx - floor(fx);
      float b = fy - floor(fy);

      float fXor = (a + b + 2.0 * a * b) + t;
      
      int index = x + y * width;

      framebuffer.pixels[index] = color(
        (fXor * 150) % 255,
        (fXor * 200) % 255, 
        (fXor * 255) % 255
      );
    }

  }
  
  framebuffer.updatePixels();
  image(framebuffer, 0, 0);
  
  if (saving) {
    saveFrame(saveDir + "/frame_" + nf(frameCounter++, 4) + ".png");
  }

}

void keyPressed() {
  
  if (key == 'r' || key == 'R') setup();
  if (key == 's' || key == 'S') saving = !saving;

}
