// Bit wave tiles pattern //

int WIDTH = 960;
int HEIGHT = 540;

PImage framebuffer;

float t = 0;
float zoom = 0.008;

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
  
  t = t + 0.2;

  for (int x = 0; x < width; x++) {
    
    for (int y = 0; y < height; y++) {
      
      float n1 = noise(x * 0.01, y * 0.01, t * 0.5);

      float fx = (x * zoom) + t + n1;
      float fy = (y * zoom) + t + n1;

      float a = fx - floor(fx);
      float b = fy - floor(fy);

      float fXor = (a + b - 2.0 * a * b) + n1 * 0.1;
      int glitch1 = (int)(fXor * 3) % 2;
      float fOr  = (a + b - a * b) + n1 * 0.1;
      int glitch2 = (int)(fOr * 5) % 3;
      float fAnd = (a * b) + n1 * 0.1;
      int glitch3 = (int)(fAnd * 7) % 5;
      
      int index = x + y * width;
      

      int ix = (int)(x + t * 50); 
      int iy = (int)(y + t * 30);

      int bitMask = (ix ^ iy) & (ix + iy); 

      framebuffer.pixels[index] = color(
        ((fXor * 150 + t * 10) * (bitMask % 2)) % 255, 
        ((fOr  * 200 + t * 20) * glitch2) % 255, 
        ((fAnd * 255 + t * 30) * glitch3) % 255
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
