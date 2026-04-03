// Bit glitch tiles pattern //

int WIDTH = 960;
int HEIGHT = 540;

PImage framebuffer;

float t = 0;
float zoom = 0.007;

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
      float n2 = noise(x * 0.01 + n1, y * 0.01 + n1, t * 0.8);

      float fx = (x * zoom) + t + n2 * 0.5;
      float fy = (y * zoom) + t + n2 * 0.5;

      float a = fx - floor(fx);
      float b = fy - floor(fy);

      float fXor = (a + b - 2.0 * a * b) + n1 * 0.1;
      int glitch1 = (int)(fXor * 8) % 2;
      float fOr  = (a + b - a * b) + n1 * 0.1;
      int glitch2 = (int)(fOr * 8) % 3;
      float fAnd = (a * b) + n1 * 0.1;
      int glitch3 = (int)(fAnd * 8) % 4;
      
      int index = x + y * width;

      framebuffer.pixels[index] = color(
        (glitch1 * 150 + t * 20) % 255,
        (glitch2 * 200 + t * 15) % 255, 
        (glitch3 * 250 + t * 10) % 255
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
