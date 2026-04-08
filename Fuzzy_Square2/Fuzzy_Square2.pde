// Fuzzy xor munching square pattern //

int w = 960;
int h = 540;

PImage framebuffer;

float[][] state;
float time = 0;

float[][] buffer;

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
      state[x][y] = (x + y) / float(w + h);
    }
  }
  
  colorMode(HSB, 1.0);
  background(0);
  frameRate(60);
  
  time = 0;

}

float fuzzyTransform(float x, float y, float current, float time) {
  
  float munchBase = (((int(x + time * 20) ^ int(y + time * 15))+time*30) % 256) / 255.0;
  
  float fuzzyInput = 1.0 / (1.0 + exp(-(munchBase - 0.5) * 10));
  
  float neighborSum = 0;
  float weightSum = 0;
  
  for (int dx = -1; dx <= 1; dx++) {
    for (int dy = -1; dy <= 1; dy++) {
      if (dx == 0 && dy == 0) continue;
      int nx = (int)(x + dx + w) % w;
      int ny = (int)(y + dy + h) % h;
      
      float distWeight = 1.0 / (abs(dx) + abs(dy) + 1);
      float fuzzyWeight = 1.0 / (1.0 + exp(-(state[nx][ny] - 0.5) * 8));
      float weight = distWeight * (0.5 + fuzzyWeight * 0.5);
      
      neighborSum += state[nx][ny] * weight;
      weightSum += weight;
    }
  }
  
  float fuzzyNeighbor = neighborSum / weightSum;

  float fuzzyRule;
  if (fuzzyInput > 0.6) {
    fuzzyRule = lerp(current, munchBase, 0.2); 
    fuzzyRule = lerp(fuzzyRule, fuzzyNeighbor, 0.1);
  } else if (fuzzyInput < 0.4) {
    fuzzyRule = lerp(current, 0, 0.1);
    fuzzyRule = lerp(fuzzyRule, fuzzyNeighbor, 0.05);
  } else {
    fuzzyRule = lerp(current, fuzzyNeighbor, 0.05);
  }

  float feedback = sin(current * PI * 10) * 0.02;
  fuzzyRule += feedback;

  return constrain(fuzzyRule, 0, 1);

}

void draw() {
  
  time += 0.1;
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      buffer[x][y] = fuzzyTransform(x, y, state[x][y], time);
    }
  }
  
  framebuffer.loadPixels();
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      state[x][y] = buffer[x][y];
      
      float val = state[x][y];
      float hue = val + time * 0.05;
      hue -= floor(hue);

      framebuffer.pixels[y * w + x] = color(hue, 0.8, val);
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
