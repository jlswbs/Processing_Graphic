// Fuzzy xor munching square pattern //

int w = 960;
int h = 540;

PImage framebuffer;

float[][] state;
float time = 0;

boolean saving = false;
int frameCounter = 0;
String saveDir = "frames";

void setup() {
  
  size(100, 100, P2D);
  surface.setSize(w, h);
  
  framebuffer = createImage(w, h, ARGB);
  noSmooth();
  
  state = new float[w][h];
  
  colorMode(RGB, 1.0);
  background(0);
  frameRate(60);
  
  time = 0;

}

float munching(int x, int y, float offset) {
  int xp = (int)(x + offset) & 255;
  int yp = (int)(y + offset) & 255;
  return (xp ^ yp) / 255.0;
}

void draw() {
  
  time += 0.05;
  
  framebuffer.loadPixels();
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float munchStatic = munching(x, y, 0);
      float munchDynamic = munching(x, y, time * 25);
      float munchValue = (munchStatic + munchDynamic) * 0.7 + munching(x, y, time * 50) * 0.3;
      
      float neighborSum = 0;
      float totalWeight = 0;
      
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          if (dx == 0 && dy == 0) continue;
          
          int nx = (x + dx + w) % w;
          int ny = (y + dy + h) % h;
          
          float weight = 1.0 / (abs(dx) + abs(dy));
          neighborSum += state[nx][ny] * weight;
          totalWeight += weight;
        }
      }
      
      float neighborValue = neighborSum / totalWeight;
      
      float diffToNeighbor = neighborValue - state[x][y];
      float munchInfluence = (munchValue - 0.5) * 0.15;
      
      float fusionStrength = 0.12 * (1 - abs(state[x][y] - neighborValue));
      
      float delta = munchInfluence 
                  + diffToNeighbor * fusionStrength
                  + sin(state[x][y] * TWO_PI) * 0.05;
      
      state[x][y] = constrain(state[x][y] + delta, 0, 1);
      
      float val = state[x][y];
      float r = val * 1.2;
      float g = val * val * 1.5;
      float b = pow(1 - val, 1.5);
      
      framebuffer.pixels[y * w + x] = color(min(r, 1.0), min(g, 1.0), min(b, 1.0));
      
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
