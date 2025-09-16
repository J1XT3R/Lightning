
int posX = 200;
int posY = 200;

int colorR = 100;
int colorG = 200;
int colorB = 100;
PGraphics pg;

ArrayList<PVector> snake;
ArrayList<PVector> food;
int snakeSize = 1;
int score = 0;
boolean gameOver = false;

ArrayList<ArrayList<PVector>> aiSnakes;
ArrayList<Integer> aiSnakeSizes;
ArrayList<Float> aiPosXs;
ArrayList<Float> aiPosYs;
ArrayList<Float> aiTargetXs;
ArrayList<Float> aiTargetYs;
ArrayList<Integer> aiLastMoveTimes;
int aiMoveInterval = 50;
float aiSpeed = 3.5;
ArrayList<Integer> aiFoodEatens;
ArrayList<Integer> aiLastFoodTimes;

ArrayList<Float> aiChargeLevels;
ArrayList<Boolean> aiCanTeleports;
ArrayList<Integer> aiLastChargeTimes;
int aiChargeInterval = 4000;
ArrayList<Integer> aiLastTeleportTimes;
int aiTeleportCooldown = 2000;

int gameTicks = 0;
int difficultyThreshold = 3000;
int cameraShakeX = 0;
int cameraShakeY = 0;
int shakeDuration = 0;

ArrayList<PVector> deathOrbs;
ArrayList<Float> orbLifespan;

float chargeLevel = 0;
float maxCharge = 100;
boolean canTeleport = false;
int lastChargeTime = 0;
int chargeInterval = 3000;

void setup() {
  size(400, 400);
  strokeWeight(12);
  pg = createGraphics(400, 400);
  
  snake = new ArrayList<PVector>();
  food = new ArrayList<PVector>();
  
  snake.add(new PVector(posX, posY));
  
  aiSnakes = new ArrayList<ArrayList<PVector>>();
  aiSnakeSizes = new ArrayList<Integer>();
  aiPosXs = new ArrayList<Float>();
  aiPosYs = new ArrayList<Float>();
  aiTargetXs = new ArrayList<Float>();
  aiTargetYs = new ArrayList<Float>();
  aiLastMoveTimes = new ArrayList<Integer>();
  aiFoodEatens = new ArrayList<Integer>();
  aiLastFoodTimes = new ArrayList<Integer>();
  aiChargeLevels = new ArrayList<Float>();
  aiCanTeleports = new ArrayList<Boolean>();
  aiLastChargeTimes = new ArrayList<Integer>();
  aiLastTeleportTimes = new ArrayList<Integer>();
  
  addAISnake(300, 300);
  
  deathOrbs = new ArrayList<PVector>();
  orbLifespan = new ArrayList<Float>();
  
  lastChargeTime = millis();
  
  for (int i = 0; i < 20; i++) {
    spawnFood();
  }
}

void draw() {
  if (gameOver) {
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("GAME OVER", width/2, height/2 - 20);
    textSize(16);
    text("Score: " + score, width/2, height/2 + 20);
    text("Click to restart", width/2, height/2 + 50);
    return;
  }
  
  float dx = mouseX - posX;
  float dy = mouseY - posY;
  float distance = sqrt(dx*dx + dy*dy);
  float speed = 2.5;
  
  if (distance > 0) {
    float moveX = (dx / distance) * speed;
    float moveY = (dy / distance) * speed;
    
    posX += moveX;
    posY += moveY;
  }
  
  updateTeleportCharge();
  
  colorR = colorR + (int) (Math.random()*20-10);
  if (colorR > 100) {
    colorR -= 10;
  }
  if (colorR < 0){
    colorR = 0;
  }
  colorG = colorG + (int) (Math.random()*40-20);
  if (colorG > 200) {
    colorG -= 20;
  }
  if (colorG < 0){
    colorG = 0;
  }
  colorB = colorB + (int) (Math.random()*20-10);
  if (colorB > 100) {
    colorB -= 10;
  }
  if (colorB < 0){
    colorB = 0;
  }
  
  pg.beginDraw();
  pg.background(0, 10);
  pg.fill(colorR, colorG, 255);
  pg.noStroke();
  pg.ellipse(posX, posY, 10, 10);
  pg.stroke(colorR, colorG, 255);
  pg.endDraw();
  image(pg, 0, 0);
  stroke(colorR, colorG, 255);
  
  updateSnake();
  updateAllAISnakes();
  updateAllAITeleports();
  updateDeathOrbs();
  updateGameTicks();
  updateCameraShake();
  
  drawSnake();
  drawAllAISnakes();
  drawFood();
  drawDeathOrbs();
  drawUI();
}

void updateSnake() {
  snakeSize = 1 + (score / 50);
  
  snake.add(0, new PVector(posX, posY));
  
  if (snake.size() > snakeSize) {
    snake.remove(snake.size() - 1);
  }
  
  checkFoodCollision();
  
  if (posX < 0 || posX >= width || posY < 0 || posY >= height) {
    gameOver = true;
  }
  
  checkAICollision();
}

void drawSnake() {
  for (int i = 0; i < snake.size(); i++) {
    PVector segment = snake.get(i);
    
    float alpha, size;
    if (snake.size() > 1) {
      alpha = map(i, 0, snake.size()-1, 200, 80);
      size = map(i, 0, snake.size()-1, 12, 6);
    } else {
      alpha = 200;
      size = 12;
    }
    
    fill(colorR, colorG, 255, alpha);
    noStroke();
    ellipse(segment.x, segment.y, size, size);
  }
}

void updateTeleportCharge() {
  int currentTime = millis();
  int elapsed = currentTime - lastChargeTime;
  
  if (elapsed < chargeInterval) {
    chargeLevel = map(elapsed, 0, chargeInterval, 0, maxCharge);
    canTeleport = false;
  } else {
    chargeLevel = maxCharge;
    canTeleport = true;
  }
}

void drawFood() {
  for (PVector f : food) {
    fill(255, 255, 0, 200);
    noStroke();
    ellipse(f.x, f.y, 8, 8);
  }
}

void addAISnake(float x, float y) {
  ArrayList<PVector> newSnake = new ArrayList<PVector>();
  for (int i = 0; i < 8; i++) {
    newSnake.add(new PVector(x - i * 8, y));
  }
  aiSnakes.add(newSnake);
  aiSnakeSizes.add(8);
  aiPosXs.add(x);
  aiPosYs.add(y);
  aiTargetXs.add(x);
  aiTargetYs.add(y);
  aiLastMoveTimes.add(millis());
  aiFoodEatens.add(0);
  aiLastFoodTimes.add(millis());
  aiChargeLevels.add(0.0);
  aiCanTeleports.add(false);
  aiLastChargeTimes.add(millis());
  aiLastTeleportTimes.add(0);
}

void updateAllAISnakes() {
  for (int i = 0; i < aiSnakes.size(); i++) {
    updateAISnake(i);
  }
}

void updateAISnake(int index) {
  int currentTime = millis();
  if (currentTime - aiLastMoveTimes.get(index) >= aiMoveInterval) {
    int newSize = 8 + (aiFoodEatens.get(index) / 2) + (score / 50);
    aiSnakeSizes.set(index, newSize);
    
    if (aiCanTeleports.get(index) && currentTime - aiLastTeleportTimes.get(index) >= aiTeleportCooldown) {
      performAITeleport(index);
    } else {
      PVector target = getAITarget(index);
      aiTargetXs.set(index, target.x);
      aiTargetYs.set(index, target.y);
      
      moveAITowardsTarget(index);
    }
    
    float newX = constrain(aiPosXs.get(index), 15, width - 15);
    float newY = constrain(aiPosYs.get(index), 15, height - 15);
    aiPosXs.set(index, newX);
    aiPosYs.set(index, newY);
    
    aiSnakes.get(index).add(0, new PVector(newX, newY));
    
    if (aiSnakes.get(index).size() > aiSnakeSizes.get(index)) {
      aiSnakes.get(index).remove(aiSnakes.get(index).size() - 1);
    }
    
    checkAIFoodCollision(index);
    
    aiLastMoveTimes.set(index, currentTime);
  }
}

void updateAllAITeleports() {
  for (int i = 0; i < aiSnakes.size(); i++) {
    updateAITeleport(i);
  }
}

void updateAITeleport(int index) {
  int currentTime = millis();
  int elapsed = currentTime - aiLastChargeTimes.get(index);
  
  if (aiFoodEatens.get(index) >= 3) {
    if (elapsed < aiChargeInterval) {
      float chargeLevel = map(elapsed, 0, aiChargeInterval, 0, 100);
      aiChargeLevels.set(index, chargeLevel);
      aiCanTeleports.set(index, false);
    } else {
      aiChargeLevels.set(index, 100.0);
      aiCanTeleports.set(index, true);
    }
  }
}

void performAITeleport(int index) {
  PVector teleportTarget = getAITeleportTarget(index);
  
  createAILightningBolt(aiPosXs.get(index), aiPosYs.get(index), teleportTarget.x, teleportTarget.y);
  
  aiPosXs.set(index, teleportTarget.x);
  aiPosYs.set(index, teleportTarget.y);
  
  aiChargeLevels.set(index, 0.0);
  aiCanTeleports.set(index, false);
  aiLastChargeTimes.set(index, millis());
  aiLastTeleportTimes.set(index, millis());
}

PVector getAITeleportTarget(int index) {
  if (snake.size() > 1) {
    PVector playerHead = snake.get(0);
    float distToPlayer = dist(aiPosXs.get(index), aiPosYs.get(index), playerHead.x, playerHead.y);
    
    if (distToPlayer > 80) {
      float angle = atan2(playerHead.y - aiPosYs.get(index), playerHead.x - aiPosXs.get(index)) + random(-PI/4, PI/4);
      float closeX = playerHead.x + cos(angle) * 60;
      float closeY = playerHead.y + sin(angle) * 60;
      return new PVector(closeX, closeY);
    }
    
    float angle = atan2(playerHead.y - aiPosYs.get(index), playerHead.x - aiPosXs.get(index)) + PI;
    float behindX = playerHead.x + cos(angle) * 70;
    float behindY = playerHead.y + sin(angle) * 70;
    return new PVector(behindX, behindY);
  }
  
  PVector nearestFood = findNearestFood(aiPosXs.get(index), aiPosYs.get(index));
  if (nearestFood != null) {
    return nearestFood;
  }
  
  return new PVector(random(50, width - 50), random(50, height - 50));
}

void createAILightningBolt(float startX, float startY, float endX, float endY) {
  float tempX = startX;
  float tempY = startY;
  int maxSteps = 20;
  int steps = 0;
  
  stroke(255, 100, 100);
  
  while ((abs(tempX - endX) > 5 || abs(tempY - endY) > 5) && steps < maxSteps) {
    if (endX - tempX > 0) {
      tempX += random(5, 15);
    } else {
      tempX -= random(5, 15);
    }
    if (endY - tempY > 0) {
      tempY += random(-10, 10);
    } else {
      tempY -= random(-10, 10);
    }
    
    line(tempX, tempY, tempX + random(-5, 5), tempY + random(-5, 5));
    steps++;
  }
}

PVector getAITarget(int index) {
  if (snake.size() > 1) {
    PVector playerHead = snake.get(0);
    float distToPlayer = dist(aiPosXs.get(index), aiPosYs.get(index), playerHead.x, playerHead.y);
    
    if (distToPlayer < 150) {
      float angle = atan2(playerHead.y - aiPosYs.get(index), playerHead.x - aiPosXs.get(index)) + PI;
      float behindX = playerHead.x + cos(angle) * 40;
      float behindY = playerHead.y + sin(angle) * 40;
      return new PVector(behindX, behindY);
    }
    
    if (distToPlayer < 200) {
      float angle = atan2(playerHead.y - aiPosYs.get(index), playerHead.x - aiPosXs.get(index)) + PI/3;
      float circleX = playerHead.x + cos(angle) * 50;
      float circleY = playerHead.y + sin(angle) * 50;
      return new PVector(circleX, circleY);
    }
    
    PVector playerTarget = findNearestFood(playerHead.x, playerHead.y);
    if (playerTarget != null) {
      float interceptX = playerHead.x + (playerTarget.x - playerHead.x) * 0.6;
      float interceptY = playerHead.y + (playerTarget.y - playerHead.y) * 0.6;
      return new PVector(interceptX, interceptY);
    }
    
    return playerHead;
  }
  
  PVector nearestFood = findNearestFood(aiPosXs.get(index), aiPosYs.get(index));
  if (nearestFood != null) {
    return nearestFood;
  }
  
  return new PVector(random(50, width - 50), random(50, height - 50));
}

void moveAITowardsTarget(int index) {
  float dx = aiTargetXs.get(index) - aiPosXs.get(index);
  float dy = aiTargetYs.get(index) - aiPosYs.get(index);
  float distance = sqrt(dx*dx + dy*dy);
  
  if (distance > 0) {
    float moveX = (dx / distance) * aiSpeed;
    float moveY = (dy / distance) * aiSpeed;
    
    moveX += random(-0.3, 0.3);
    moveY += random(-0.3, 0.3);
    
    aiPosXs.set(index, aiPosXs.get(index) + moveX);
    aiPosYs.set(index, aiPosYs.get(index) + moveY);
  }
}

void drawAllAISnakes() {
  for (int snakeIndex = 0; snakeIndex < aiSnakes.size(); snakeIndex++) {
    ArrayList<PVector> currentSnake = aiSnakes.get(snakeIndex);
    for (int i = 0; i < currentSnake.size(); i++) {
      PVector segment = currentSnake.get(i);
      
      float alpha, size;
      if (currentSnake.size() > 1) {
        alpha = map(i, 0, currentSnake.size()-1, 180, 60);
        size = map(i, 0, currentSnake.size()-1, 10, 4);
      } else {
        alpha = 180;
        size = 10;
      }
      
      fill(255, 100, 100, alpha);
      noStroke();
      ellipse(segment.x + cameraShakeX, segment.y + cameraShakeY, size, size);
    }
  }
}

void checkFoodCollision() {
  for (int i = food.size() - 1; i >= 0; i--) {
    PVector f = food.get(i);
    if (dist(posX, posY, f.x, f.y) < 15) {
      food.remove(i);
      score += 10;
      spawnFood();
    }
  }
}

void checkAIFoodCollision(int index) {
  for (int i = food.size() - 1; i >= 0; i--) {
    PVector f = food.get(i);
    if (dist(aiPosXs.get(index), aiPosYs.get(index), f.x, f.y) < 15) {
      food.remove(i);
      aiFoodEatens.set(index, aiFoodEatens.get(index) + 1);
      aiLastFoodTimes.set(index, millis());
      spawnFood();
    }
  }
}

void checkAICollision() {
  for (int snakeIndex = 0; snakeIndex < aiSnakes.size(); snakeIndex++) {
    ArrayList<PVector> currentSnake = aiSnakes.get(snakeIndex);
    if (currentSnake.size() > 1) {
      for (int i = 1; i < currentSnake.size(); i++) {
        PVector aiSegment = currentSnake.get(i);
        if (dist(posX, posY, aiSegment.x, aiSegment.y) < 12) {
          gameOver = true;
          return;
        }
      }
    }
    
    if (snake.size() > 1) {
      for (int i = 1; i < snake.size(); i++) {
        PVector playerSegment = snake.get(i);
        if (dist(aiPosXs.get(snakeIndex), aiPosYs.get(snakeIndex), playerSegment.x, playerSegment.y) < 12) {
          createDeathOrbs(aiPosXs.get(snakeIndex), aiPosYs.get(snakeIndex));
          aiSnakes.remove(snakeIndex);
          aiSnakeSizes.remove(snakeIndex);
          aiPosXs.remove(snakeIndex);
          aiPosYs.remove(snakeIndex);
          aiTargetXs.remove(snakeIndex);
          aiTargetYs.remove(snakeIndex);
          aiLastMoveTimes.remove(snakeIndex);
          aiFoodEatens.remove(snakeIndex);
          aiLastFoodTimes.remove(snakeIndex);
          aiChargeLevels.remove(snakeIndex);
          aiCanTeleports.remove(snakeIndex);
          aiLastChargeTimes.remove(snakeIndex);
          aiLastTeleportTimes.remove(snakeIndex);
          score += 50;
          break;
        }
      }
    }
  }
}

void createDeathOrbs(float x, float y) {
  for (int i = 0; i < 8; i++) {
    float angle = (TWO_PI / 8) * i;
    float orbX = x + cos(angle) * 20;
    float orbY = y + sin(angle) * 20;
    deathOrbs.add(new PVector(orbX, orbY));
    orbLifespan.add(60.0);
  }
}

void updateDeathOrbs() {
  for (int i = deathOrbs.size() - 1; i >= 0; i--) {
    orbLifespan.set(i, orbLifespan.get(i) - 1);
    
    if (orbLifespan.get(i) <= 0) {
      deathOrbs.remove(i);
      orbLifespan.remove(i);
    }
  }
}

void drawDeathOrbs() {
  for (int i = 0; i < deathOrbs.size(); i++) {
    PVector orb = deathOrbs.get(i);
    float life = orbLifespan.get(i);
    float alpha = map(life, 0, 60, 0, 255);
    float size = map(life, 0, 60, 0, 8);
    
    fill(255, 255, 0, alpha);
    noStroke();
    ellipse(orb.x, orb.y, size, size);
  }
}

PVector findNearestFood(float x, float y) {
  PVector nearest = null;
  float minDist = Float.MAX_VALUE;
  
  for (PVector f : food) {
    float dist = dist(x, y, f.x, f.y);
    if (dist < minDist) {
      minDist = dist;
      nearest = f;
    }
  }
  
  return nearest;
}

void updateGameTicks() {
  gameTicks++;
  if (gameTicks >= difficultyThreshold) {
    gameTicks = 0;
    difficultyThreshold += 2000;
    float spawnX = random(50, width - 50);
    float spawnY = random(50, height - 50);
    createLightningStrike(spawnX, spawnY);
    addAISnake(spawnX, spawnY);
  }
}

void updateCameraShake() {
  if (shakeDuration > 0) {
    cameraShakeX = (int)random(-5, 5);
    cameraShakeY = (int)random(-5, 5);
    shakeDuration--;
  } else {
    cameraShakeX = 0;
    cameraShakeY = 0;
  }
}

void createLightningStrike(float x, float y) {
  shakeDuration = 30;
  
  float tempStartX = x;
  float tempStartY = 0;
  float tempEndX = x;
  float tempEndY = 0;
  
  stroke(255, 255, 255, 200);
  strokeWeight(2);
  
  while (tempEndY < y) {
    tempEndX = tempStartX + (int)(Math.random() * 20 - 10);
    tempEndY = tempStartY + (int)(Math.random() * 15 + 5);
    line(tempStartX, tempStartY, tempEndX, tempEndY);
    tempStartX = tempEndX;
    tempStartY = tempEndY;
  }
  
  strokeWeight(12);
}

void createTeleportLightning(float startX, float startY, float endX, float endY) {
  int maxSteps = 30;
  int steps = 0;
  float tempStartX = startX;
  float tempStartY = startY;
  float tempEndX = startX;
  float tempEndY = startY;
  
  stroke(colorR, colorG, 255, 200);
  strokeWeight(3);
  
  while ((abs(tempStartX - endX) > 5 || abs(tempStartY - endY) > 5) && steps < maxSteps) {
    if (endX - tempStartX > 0) {
      tempEndX = tempStartX + (int) (Math.random()*20);
    } else {
      tempEndX = tempStartX - (int) (Math.random()*20);
    }
    if (endY - tempStartY > 0) {
      tempEndY = tempStartY + (int) ((Math.random()*20));
    } else {
      tempEndY = tempStartY  - (int) ((Math.random()*20));
    }
    line(tempStartX, tempStartY, tempEndX, tempEndY);
    tempStartX = tempEndX;
    tempStartY = tempEndY;
    steps++;
  }
  
  strokeWeight(12);
}

void drawUI() {
  fill(255);
  textAlign(LEFT);
  textSize(16);
  text("Score: " + score, 10, 25);
  
  drawChargeBar();
}

void drawChargeBar() {
  float barWidth = width - 40;
  float barHeight = 20;
  float barX = 20;
  float barY = height - 30;
  float fillWidth = (chargeLevel / maxCharge) * barWidth;
  
  fill(30, 30, 30, 150);
  noStroke();
  rect(barX, barY, barWidth, barHeight, 8);
  
  if (chargeLevel > 0) {
    if (canTeleport) {
      fill(colorR, colorG, 100, 180);
    } else {
      fill(colorR, colorG, 100, 160);
    }
    noStroke();
    rect(barX, barY, fillWidth, barHeight, 8);
  }
  
  strokeWeight(1);
  stroke(100, 100, 100, 120);
  noFill();
  rect(barX, barY, barWidth, barHeight, 8);
  
  textAlign(CENTER);
  textSize(12);
  
  if (canTeleport) {
    fill(colorR, colorG, 255, 200);
    text("TELEPORT READY", width/2, barY - 8);
  } else {
    int remaining = (chargeInterval - (millis() - lastChargeTime)) / 1000 + 1;
    fill(200, 200, 200, 180);
    text("CHARGING... " + remaining + "s", width/2, barY - 8);
  }
  
  fill(150, 150, 150, 120);
  textSize(9);
  text(int(chargeLevel) + "%", width/2, barY + barHeight + 12);
}


void spawnFood() {
  PVector newFood = new PVector(
    random(20, width - 20),
    random(20, height - 20)
  );
  food.add(newFood);
}


void mousePressed() {
  if (gameOver) {
    gameOver = false;
    score = 0;
    snakeSize = 1;
    snake.clear();
    food.clear();
    posX = 200;
    posY = 200;
    snake.add(new PVector(posX, posY));
    
    aiSnakes.clear();
    aiSnakeSizes.clear();
    aiPosXs.clear();
    aiPosYs.clear();
    aiTargetXs.clear();
    aiTargetYs.clear();
    aiLastMoveTimes.clear();
    aiFoodEatens.clear();
    aiLastFoodTimes.clear();
    aiChargeLevels.clear();
    aiCanTeleports.clear();
    aiLastChargeTimes.clear();
    aiLastTeleportTimes.clear();
    
    addAISnake(300, 300);
    
    gameTicks = 0;
    difficultyThreshold = 3000;
    
    deathOrbs.clear();
    orbLifespan.clear();
    
    chargeLevel = 0;
    canTeleport = false;
    lastChargeTime = millis();
    for (int i = 0; i < 20; i++) {
      spawnFood();
    }
    return;
  }
  
  if (canTeleport) {
    createTeleportLightning(posX, posY, mouseX, mouseY);
    
    posX = mouseX;
    posY = mouseY;
    
    chargeLevel = 0;
    canTeleport = false;
    lastChargeTime = millis();
    
    stroke(colorR, colorG, 255);
    fill(colorR, colorG, 255);
    ellipse(posX, posY, 25, 25);
  }
}
