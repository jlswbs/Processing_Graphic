// Fuzzy xor munching square pattern //

int w = 960;
int h = 540;

PImage framebuffer;

float[][] state;
float[][] buffer;
float time = 0;

float fusionStrength = 0.15;
float diffusionRate = 0.03;
float noiseAmount = 0.02;

boolean saving = false;
int frameCounter = 0;
String saveDir = "frames";

void setup() {
  
  size(100, 100, P2D);
  surface.setSize(w, h);
  
  framebuffer = createImage(w, h, ARGB);
  noSmooth();
  
  state = new float[w][h];
  buffer = new float[w][h];
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      state[x][y] = random(1);
    }
  }
  
  colorMode(RGB, 1.0);
  background(0);
  frameRate(60);
  
  time = 0;
  
}

void draw() {
  
  time += 0.025;
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float munchingVal = ((x ^ y) % 256) / 255.0;
      
      int xShift = (int)(x + time * 20) % w;
      int yShift = (int)(y + time * 15) % h;
      float munchingMoving = ((xShift ^ yShift) % 256) / 255.0;
      
      float basePattern = (munchingVal + munchingMoving) / 2.0;
      
      float fusion = 0;
      int neighbors = 0;
      
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx == 0 && dy == 0) continue;
          int nx = (x + dx + w) % w;
          int ny = (y + dy + h) % h;
          fusion += state[nx][ny];
          neighbors++;
        }
      }
      fusion /= neighbors;
      
      float diff = fusion - state[x][y];
      float fusionEffect = diff * fusionStrength;
      
      float diffusion = 0;
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx == 0 && dy == 0) continue;
          int nx = (x + dx + w) % w;
          int ny = (y + dy + h) % h;
          diffusion += (state[nx][ny] - state[x][y]);
        }
      }
      diffusion = diffusion * diffusionRate / 8.0;
      
      float absorption = 0;
      if (basePattern > 0.5) {
        absorption = sin(state[x][y] * PI) * 0.1;
      } else {
        absorption = cos(time + x * 0.1 + y * 0.1) * 0.05;
      }
      
      float newVal = state[x][y] 
                    + fusionEffect 
                    + diffusion 
                    + absorption
                    + noiseAmount * (random(1) - 0.5);
      
      newVal = lerp(newVal, basePattern, 0.1);
      
      buffer[x][y] = constrain(newVal, 0, 1);
    }
  }
  
  framebuffer.loadPixels();
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      state[x][y] = buffer[x][y];
      
      float val = state[x][y];
      
      float gradX = 0, gradY = 0;
      if (x > 0 && x < w-1 && y > 0 && y < h-1) {
        gradX = abs(state[x+1][y] - state[x-1][y]);
        gradY = abs(state[x][y+1] - state[x][y-1]);
      }
      float edge = (gradX + gradY) * 2;
      
      float r = val * (1 + edge * 0.5);
      float g = val * val * (1 - edge * 0.3);
      float b = (1 - val) * (1 - edge * 0.2);
      
      framebuffer.pixels[y * w + x] = color(r, g, b);
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
