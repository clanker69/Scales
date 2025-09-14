color[][] outerCurrent, outerTarget;  // outer neon colors
color[][] innerCurrent, innerTarget;  // inner dark colors
float[][] angles, speeds;             // rotation angles & speeds
float[][] pupilOffsetX, pupilOffsetY; // pupil positions
int cols, rows;
float progress = 0;

void setup() {
  size(600, 800);
  noStroke();

  cols = width / 60 + 2;
  rows = height / 70 + 2;

  outerCurrent = new color[cols][rows];
  outerTarget  = new color[cols][rows];
  innerCurrent = new color[cols][rows];
  innerTarget  = new color[cols][rows];

  angles = new float[cols][rows];
  speeds = new float[cols][rows];
  pupilOffsetX = new float[cols][rows];
  pupilOffsetY = new float[cols][rows];

  // initialize all scales
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      outerCurrent[i][j] = randomNeon();
      outerTarget[i][j]  = randomNeon();
      innerCurrent[i][j] = randomDark();
      innerTarget[i][j]  = randomDark();

      angles[i][j] = 0;
      speeds[i][j] = 0.005f + (float)(Math.random() * (0.02 - 0.005));
      if (Math.random() < 0.5) speeds[i][j] *= -1;

      pupilOffsetX[i][j] = -2 + (float)(Math.random() * 4);
      pupilOffsetY[i][j] = -2 + (float)(Math.random() * 4);
    }
  }
}

void draw() {
  background(20); 

  progress += 0.01;
  if (progress >= 1) {
    progress = 0;
    // set new target colors
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        outerCurrent[i][j] = outerTarget[i][j];
        outerTarget[i][j]  = randomNeon();
        innerCurrent[i][j] = innerTarget[i][j];
        innerTarget[i][j]  = randomDark();
      }
    }
  }

  // draw all scales with nested loops
  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      int offset = (j % 2 == 0) ? 0 : 30; // stagger rows
      color outerC = lerpColor(outerCurrent[i][j], outerTarget[i][j], progress);
      color innerC = lerpColor(innerCurrent[i][j], innerTarget[i][j], progress);

      angles[i][j] += speeds[i][j]; //speed

      // slowly move pupils
      pupilOffsetX[i][j] += -0.2 + (float)(Math.random() * 0.4);
      pupilOffsetY[i][j] += -0.2 + (float)(Math.random() * 0.4);
      pupilOffsetX[i][j] = constrain(pupilOffsetX[i][j], -5, 5);
      pupilOffsetY[i][j] = constrain(pupilOffsetY[i][j], -5, 5);

      pushMatrix();
      translate(i * 60 + offset, j * 70); // move to scale center
      rotate(angles[i][j]);               // rotate in place
      scale(i * 60 + offset, j * 70, outerC, innerC, pupilOffsetX[i][j], pupilOffsetY[i][j]);
      popMatrix();
    }
  }
}

// scale function with int arguments
void scale(int x, int y, color outerC, color innerC, float pxOffset, float pyOffset) {
  fill(outerC);
  beginShape();
  vertex(-30, 0);
  bezierVertex(-30, -40, 30, -40, 30, 0);
  bezierVertex(25, 20, -25, 20, -30, 0);
  endShape(CLOSE);

  // inner dark bump
  fill(innerC);
  ellipse(0, -10, 50, 40);

  // eyeballs
  float eyeOffsetX = 12;
  float eyeOffsetY = -10;
  fill(255);
  ellipse(-eyeOffsetX, eyeOffsetY, 12, 12);
  ellipse(eyeOffsetX, eyeOffsetY, 12, 12);

  //pups
  fill(0);
  ellipse(-eyeOffsetX + pxOffset, eyeOffsetY + pyOffset, 6, 6);
  ellipse(eyeOffsetX + pxOffset, eyeOffsetY + pyOffset, 6, 6);
}

color randomNeon() {
  return color(
    150 + (int)(Math.random() * 105),
    150 + (int)(Math.random() * 105),
    150 + (int)(Math.random() * 105)
  );
}

color randomDark() {
  return color(
    (int)(Math.random() * 80),
    (int)(Math.random() * 80),
    (int)(Math.random() * 80)
  );
}
