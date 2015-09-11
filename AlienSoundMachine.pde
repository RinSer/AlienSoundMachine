// Alien Sound Machine

// Drums start
Maxim maxim;
AudioPlayer drum1;
AudioPlayer drum2;
AudioPlayer drum3;

boolean[] track1;
boolean[] track2;
boolean[] track3;

int playhead;

int numBeats;
int currentBeat;
// Drums end

// Synth start
WavetableSynth waveform;

int[] notes = {
  0, 0, 0, 12, 12, 12, 10, 10, 10, 7, 7, 7, 6, 6, 3, 3
};
boolean playit=false;

int transpose;
float fc, res, attack, release;
float dt, o, a, r, f, q;
float dt_diameter, o_diameter, a_diameter;
float r_diameter, f_diameter, q_diameter;
float[] seq = new float[16];
float[] seq_diameter = new float[16];

float[] wavetable = new float[514]; 
// Synth end

// Equalizer start
float cs1; 
float ss1;
float sy1;
float cy1;
float clr1;

float cs2; 
float ss2;
float sy2;
float cy2;
float clr2;

float cs3; 
float ss3;
float sy3;
float cy3;
float clr3;

float power1;
float power2;
float power3;
// Equalizer end


void setup() {
  size(1200, 850, P3D);
  smooth(8);
  numBeats = 16;
  currentBeat = 0;
  
  colorMode(HSB);
  
  maxim = new Maxim(this);
  drum1 = maxim.loadFile("Flash-laser-01.wav");
  drum1.setLooping(false);
  drum1.setAnalysing(true);
  drum2 = maxim.loadFile("Slime-gun-01.wav");
  drum2.setLooping(false);
  drum2.setAnalysing(true);
  drum3 = maxim.loadFile("Space-hole-02.wav");
  drum3.setLooping(false);
  drum3.setAnalysing(true);
  
  // set up the sequences
  track1 = new boolean[numBeats];
  track2 = new boolean[numBeats];
  track3 = new boolean[numBeats];
  
  // create Synth
  waveform = maxim.createWavetableSynth(128);
  for (int i = 0; i < 514 ; i++) {

    wavetable[i]=((float)i/514)-0.5;
  }

  waveform.waveTableSize(514);
  waveform.loadWaveTable(wavetable);
  waveform.volume(0.5);
  
  frameRate(32);
}

void draw() {
  
  background(0);
  
  // Drums start
  for (int i = 1; i < 4; i++) {
    for (int j = 1; j < numBeats+1; j++) {
      noFill();
      stroke(255);
      strokeWeight(2);
      ellipse(j*75-40, 550+i*75, 50, 50);
      fill(255);
      ellipse((currentBeat+1)*75-40, 550+i*75, 50, 50);
    }
  }
  
  for (int b = 1; b < numBeats+1; b++) {
    stroke(15+b*15, 250, 250);
    strokeWeight(5);
    fill(0);
    if (track1[b-1]) {
      ellipse(b*75-40, 550+75, 50, 50);
    }
    if (track2[b-1]) {
      ellipse(b*75-40, 550+2*75, 50, 50);
    }
    if (track3[b-1]) {
      ellipse(b*75-40, 550+3*75, 50, 50);
    }
  }
  
  for (int i = 1; i < 4; i++) {
    /*stroke(15+currentBeat*30, 125+i*30, 50*i, 125);
    strokeWeight(2);*/
    noStroke();
    fill(15+currentBeat*15, 125+i*30, 50*i, 225);
    ellipse((currentBeat+1)*75-40, 550+i*75, 50, 50);
  }
  
  playhead ++;
  //if (frameCount%4==0) {// 4 frames have passed check if we need to play a beat
  if(playhead % 4 == 0){
    // Synth play
    waveform.setFrequency(mtof[notes[playhead/4%16]+30]);
    
    if (track1[currentBeat]) // track1 wants to play on this beat
    {
      drum1.cue(0);
      drum1.play();
    }
    if (track2[currentBeat]) {
      drum2.cue(0);
      drum2.play();
    }
    if (track3[currentBeat]) {
      drum3.cue(0);  
      drum3.play();
    }
    // move to the next beat ready for next time
    currentBeat++;
    if (currentBeat >= numBeats)
      currentBeat = 0;
    
  }
  // Drums end
  
  // Synth start
  waveform.play();
  // Controls
  fill(0);
  stroke(15+currentBeat*15, 250, 250);
  strokeWeight(5);
  dt_diameter = 50 + dt;
  ellipse(150, 100, dt_diameter, 50);
  a_diameter = 50 + a;
  ellipse(150, 200, a_diameter, 50);
  r_diameter = 50 + r;
  ellipse(150, 300, r_diameter, 50);
  o_diameter = 50 + o*1.25;
  ellipse(1050, 100, o_diameter, 50);
  f_diameter = 50 + f;
  ellipse(1050, 200, f_diameter, 50);
  q_diameter = 50 + q;
  ellipse(1050, 300, q_diameter, 50);
  
  for (int i = 0; i < notes.length; i++) {
    fill(0);
    stroke(15+currentBeat*15, 250, 250);
    strokeWeight(5);
    seq_diameter[i] = 50 + seq[i]/2;
    ellipse((i+1)*75-40, 475, 50, seq_diameter[i]);
  }
  
  
  // Equalizer start
  power1 = drum1.getAveragePower();
  power2 = drum2.getAveragePower();
  power3 = drum3.getAveragePower();
  
  float y1 = map(power2+1, 0.5, 1.5, 0, TWO_PI);
  //float x1 = map(power2+1, 0.5, 1.5, 0, TWO_PI);
  float y2 = map(power1+1, 0.5, 1.5, 0, TWO_PI);
  //float x2 = map(power1+1, 0.5, 1.5, 0, TWO_PI);
  float y3 = map(power3+1, 0.5, 1.5, 0, TWO_PI);
  //float x3 = map(power3+1, 0.5, 1.5, 0, TWO_PI);
  clr1 = 15+currentBeat*15;
  clr2 = 15+currentBeat*15;
  clr3 = 15+currentBeat*15;
  color rc1 = color(clr1, 255, 255);
  color rd1 = color(clr1-12.5, 225, 255);
  color re1 = color(clr1-25, 205, 255);
  color rc2 = color(clr2, 255, 255);
  color rd2 = color(clr2-12.5, 225, 255);
  color re2 = color(clr2-25, 205, 255);
  color rc3 = color(clr3, 255, 255);
  color rd3 = color(clr3-12.5, 225, 255);
  color re3 = color(clr3-25, 205, 255);
  cs1 = cos(y1)*100;
  ss1 = sin(y1)*100;
  sy1 = sin(y1);
  cy1 = cos(y1);
  cs2 = cos(y2)*100;
  ss2 = sin(y2)*100;
  sy2 = sin(y2);
  cy2 = cos(y2);
  cs3 = cos(y3)*100;
  ss3 = sin(y3)*100;
  sy3 = sin(y3);
  cy3 = cos(y3);
  pushMatrix();
  translate(width/2, height/3);
  noStroke();
  directionalLight(clr1, 255, 255, 0, -sy1, 0);
  fill(rc1);
  //rotateZ(x1);
  sphere(35);
  popMatrix();
  rcircle(sy1*60, cs1, rd1);
  rcircle(cy1*60, ss1, rd1);
  rcircle(sy1*50, cs1*0.8, rc1);
  rcircle(cy1*50, ss1*0.8, rc1);
  rcircle(sy1*70, cs1*1.2, re1);
  rcircle(cy1*70, ss1*1.2, re1);
  rcircle(sy1*60+5, cs1+5, rd1);
  rcircle(cy1*60+5, ss1+5, rd1);
  rcircle(sy1*50+5, cs1*0.8+5, re1);
  rcircle(cy1*50+5, ss1*0.8+5, re1);
  rcircle(sy1*70+5, cs1*1.2+5, rc1);
  rcircle(cy1*70+5, ss1*1.2+5, rc1);
  pushMatrix();
  translate(-110, 0, 0);
  pushMatrix();
  translate(width/2-75, height/3);
  noStroke();
  directionalLight(clr2, 255, 255, 0, -sy2, 0);
  fill(rc2);
  //rotateZ(x2);
  sphere(35);
  popMatrix();
  rcircle(sy2*60, cs2, rd2);
  rcircle(cy2*60, ss2, rd2);
  rcircle(sy2*50, cs2*0.8, rc2);
  rcircle(cy2*50, ss2*0.8, rc2);
  rcircle(sy2*70, cs2*1.2, re2);
  rcircle(cy2*70, ss2*1.2, re2);
  rcircle(sy2*60+5, cs2+5, rd2);
  rcircle(cy2*60+5, ss2+5, rd2);
  rcircle(sy2*50+5, cs2*0.8+5, re2);
  rcircle(cy2*50+5, ss2*0.8+5, re2);
  rcircle(sy2*70+5, cs2*1.2+5, rc2);
  rcircle(cy2*70+5, ss2*1.2+5, rc2);
  popMatrix();
  pushMatrix();
  translate(110, 0, 0);
  pushMatrix();
  translate(width/2+75, height/3);
  noStroke();
  directionalLight(clr3, 255, 255, 0, -sy3, 0);
  fill(rc3);
  //rotateZ(x3);
  sphere(35);
  popMatrix();
  rcircle(sy3*60, cs3, rd3);
  rcircle(cy3*60, ss3, rd3);
  rcircle(sy3*50, cs3*0.8, rc3);
  rcircle(cy3*50, ss3*0.8, rc3);
  rcircle(sy3*70, cs3*1.2, re3);
  rcircle(cy3*70, ss3*1.2, re3);
  rcircle(sy3*60+5, cs3+5, rd3);
  rcircle(cy3*60+5, ss3+5, rd3);
  rcircle(sy3*50+5, cs3*0.8+5, re3);
  rcircle(cy3*50+5, ss3*0.8+5, re3);
  rcircle(sy3*70+5, cs3*1.2+5, rc3);
  rcircle(cy3*70+5, ss3*1.2+5, rc3);
  popMatrix();
  // Equalizer end
  
}

void mousePressed() {
  
  for (int i = 1; i < 4; i++) {
    for (int j = 1; j < numBeats+1; j++) {
      noFill();
      stroke(255);
      strokeWeight(2);
      ellipse(j*75-40, 550+i*75, 50, 50);
      if (overCircle(j*75-40, 550+i*75, 50)) {
        
        int index = j-1;
        int track = i-1;
        
        println("index "+index);
        println("track "+track);


        if (track == 0)
          track1[index] = !track1[index];
        if (track == 1)
          track2[index] = !track2[index];
        if (track == 2)
          track3[index] = !track3[index];
      }
    }
  }
  
}

void mouseDragged() {
  
  if (overCircle(150, 100, 50)) {
    dt = map(mouseX, 125, 175, 0, 100);
    waveform.setDelayTime((float)dt/50);
  }
  if (overCircle(150, 200, 50)) {
    a = map(mouseX, 125, 175, 0, 100);
    attack = a*100;
  }
  if (overCircle(150, 300, 50)) {
    r = map(mouseX, 125, 175, 0, 100);
    release = r*100;
  }
  
  if (overCircle(1050, 100, 50)) {
    o = map(mouseX, 1025, 1075, 0, 80);
    transpose = (int)Math.floor(o);
  }
  if (overCircle(1050, 200, 50)) {
    f = map(mouseX, 1025, 1075, 0, 100);
    fc = f*100;
    waveform.setFilter(fc, res);
  }
  if (overCircle(1050, 300, 50)) {
    q = map(mouseX, 1025, 1075, 0, 100);
    res = q/100;
    waveform.setFilter(fc, res);
  }
  
  for (int i = 0; i < notes.length; i++) {
    if (overCircle((i+1)*75-40, 475, 50)) {
      seq[i] = map(mouseY, 500, 450, 0, 256);
    }
  }
  
}
  
void mouseReleased()
{
  for (int i=0;i<notes.length;i++) {

    notes[i]=(int) (Math.floor((seq[i]/256)*12+transpose)); 
  }
}

// Drum buttons
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

// Equalizer objects
void rcircle(float t, float r, color c) {
  pushMatrix();
  translate(0, t, 0);
  rotateX(PI/4);
  stroke(c);
  strokeWeight(5);
  noFill();
  ellipse(width/2, height/2, r, r);
  popMatrix();
}