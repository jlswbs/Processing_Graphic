// Plasma tiles pattern //

int WIDTH = 960;
int HEIGHT = 540;

PImage framebuffer;

float t = 0;
float zoom = 0.02;

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
      
      float fx = x * zoom + t; 
      float fy = y * zoom + t;
      
      float fuzzyXor = (sin(fx + t) * cos(fy - t) + 
                        sin(fy + t * 0.5) * cos(fx - t * 0.8)) * 32.0;

      int index = x + y * width;
      framebuffer.pixels[index] = color((fuzzyXor * 24) % 255, abs(fuzzyXor * 8) % 255, abs(fuzzyXor * 4) % 255);

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
