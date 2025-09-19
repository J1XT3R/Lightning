int startX = 0;
int startY = 150;
int endX = 0;
int endY = 150;

float playerX = 100;
float playerY = 200;
float playerSize = 20;
int playerHealth = 100;
int maxHealth = 100;
float playerSpeed = 5;

int playerAttackCooldown = 0;
int maxPlayerAttackCooldown = 30;
boolean canAttack = true;

int bossPhase = 1;
int bossHealth = 300;
int maxBossHealth = 300;
int bossAttackTimer = 0;
int bossAttackCooldown = 60;
int phaseTimer = 0;
int phaseDuration = 1800;

int bossRegenTimer = 0;
int bossRegenCooldown = 300;
int bossRegenAmount = 5;

class Minion {
  float x, y, vx, vy;
  float speed = 1.5;
  float size = 12;
  boolean active = true;
  int health = 20;
  int maxHealth = 20;
  
  Minion(float startX, float startY) {
    x = startX;
    y = startY;
    vx = 0;
    vy = 0;
  }
  
  void update() {
    if (active) {
      float dx = playerX - x;
      float dy = playerY - y;
      float distance = sqrt(dx*dx + dy*dy);
      
      if (distance > 0) {
        vx = (dx / distance) * speed;
        vy = (dy / distance) * speed;
        x += vx;
        y += vy;
      }
    }
  }
  
  void draw() {
    if (active) {
      fill(255, 0, 0);
      noStroke();
      ellipse(x, y, size, size);
      
      fill(255, 0, 0);
      rect(x - 10, y - 20, 20, 3);
      fill(0, 255, 0);
      rect(x - 10, y - 20, 20 * (float)health / maxHealth, 3);
    }
  }
  
  boolean checkHit(float px, float py, float pSize) {
    if (!active) return false;
    return dist(x, y, px, py) < pSize + size/2;
  }
  
  boolean takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      active = false;
      return true;
    }
    return false;
  }
}

class Meteor {
  float x, y, vx, vy;
  float size = 25;
  boolean active = true;
  int damage = 30;
  
  Meteor(float startX, float startY) {
    x = startX;
    y = startY;
    vx = random(-2, 2);
    vy = random(3, 6);
  }
  
  void update() {
    if (active) {
      x += vx;
      y += vy;
      
      if (y > height) {
        active = false;
      }
    }
  }
  
  void draw() {
    if (active) {
      fill(255, 100, 0);
      noStroke();
      ellipse(x, y, size, size);
      
      fill(255, 150, 0, 100);
      ellipse(x, y + 10, size * 0.8, size * 0.6);
    }
  }
  
  boolean checkHit(float px, float py, float pSize) {
    if (!active) return false;
    return dist(x, y, px, py) < pSize + size/2;
  }
}

ArrayList<Minion> minions = new ArrayList<Minion>();
ArrayList<Meteor> meteors = new ArrayList<Meteor>();

float isabellaX = 700;
float isabellaY = 200;
float isabellaSpeed = 1.5;
float isabellaTargetX = 700;
float isabellaTargetY = 200;
int isabellaMoveTimer = 0;
int isabellaMoveCooldown = 120;

ArrayList<YellowBall> yellowBalls = new ArrayList<YellowBall>();

ArrayList<LightningAttack> attacks = new ArrayList<LightningAttack>();
ArrayList<BoneAttack> bones = new ArrayList<BoneAttack>();

boolean gameActive = true;
boolean gameOver = false;
boolean playerWon = false;
String gameMessage = "ISABELLA APPEARS! Aim at her and click to attack!";
String phaseMessage = "Phase 1: Basic Lightning Strikes";

boolean isAimingAtBoss = false;
float aimDistance = 50;

color sansBlue = color(135, 206, 250);
color sansYellow = color(255, 255, 0);
color playerColor = color(255, 100, 100);

int posX = 200, posY = 200;
PGraphics lightSprite;
float lightRadius = 140;
float followSpeed = 0.15;

int baseR = 120, baseG = 200, baseB = 255;
float boost = 1.0;

class YellowBall {
  float x, y, vx, vy;
  float speed = 2;
  float size = 15;
  boolean active = true;
  int damage = 5;
  
  YellowBall(float startX, float startY) {
    x = startX;
    y = startY;
    vx = 0;
    vy = 0;
  }
  
  void update() {
    if (active) {
      float dx = playerX - x;
      float dy = playerY - y;
      float distance = sqrt(dx*dx + dy*dy);
      
      if (distance > 0) {
        vx = (dx / distance) * speed;
        vy = (dy / distance) * speed;
        x += vx;
        y += vy;
      }
    }
  }
  
  void draw() {
    if (active) {
      fill(255, 255, 0);
      noStroke();
      ellipse(x, y, size, size);
      
      fill(255, 255, 0, 100);
      ellipse(x, y, size * 1.5, size * 1.5);
    }
  }
  
  boolean checkHit(float px, float py, float pSize) {
    if (!active) return false;
    return dist(x, y, px, py) < pSize + size/2;
  }
}

float cameraShakeX = 0;
float cameraShakeY = 0;
float shakeIntensity = 0;
float shakeDecay = 0.9;

ArrayList<Warning> warnings = new ArrayList<Warning>();
int warningDuration = 60;

float screenFlash = 0;
float screenFlashDecay = 0.95;
color flashColor = color(255, 255, 255);

float bossAnimationTimer = 0;
float bossAttackCharge = 0;
boolean bossIsCharging = false;

ArrayList<Particle> particles = new ArrayList<Particle>();

int patternTimer = 0;
int currentPattern = 0;
boolean patternActive = false;

class Warning {
  float x, y, size;
  int timer;
  int maxTimer;
  color warningColor;
  String warningText;
  
  Warning(float x, float y, float size, int duration, color c, String text) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.timer = duration;
    this.maxTimer = duration;
    this.warningColor = c;
    this.warningText = text;
  }
  
  void update() {
    timer--;
  }
  
  void draw() {
    if (timer > 0) {
      float alpha = map(timer, 0, maxTimer, 0, 255);
      float pulseSize = size * (1 + 0.3 * sin(millis() * 0.01));
      
      noFill();
      stroke(warningColor, alpha);
      strokeWeight(3);
      ellipse(x, y, pulseSize, pulseSize);
      
      fill(warningColor, alpha);
      textAlign(CENTER);
      textSize(16);
      text(warningText, x, y + 5);
    }
  }
  
  boolean isActive() {
    return timer > 0;
  }
}

class Particle {
  float x, y, vx, vy;
  float life, maxLife;
  color particleColor;
  float size;
  
  Particle(float x, float y, float vx, float vy, float life, color c, float size) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.life = life;
    this.maxLife = life;
    this.particleColor = c;
    this.size = size;
  }
  
  void update() {
    x += vx;
    y += vy;
    vx *= 0.98;
    vy *= 0.98;
    life--;
  }
  
  void draw() {
    if (life > 0) {
      float alpha = map(life, 0, maxLife, 0, 255);
      fill(red(particleColor), green(particleColor), blue(particleColor), alpha);
      noStroke();
      ellipse(x, y, size, size);
    }
  }
  
  boolean isDead() {
    return life <= 0;
  }
}

class LightningAttack {
  float x, y, targetX, targetY;
  float speed = 5;
  boolean active = true;
  color attackColor;
  
  LightningAttack(float startX, float startY, float endX, float endY, color c) {
    x = startX;
    y = startY;
    targetX = endX;
    targetY = endY;
    attackColor = c;
  }
  
  void update() {
    if (active) {
      float dx = targetX - x;
      float dy = targetY - y;
      float distance = sqrt(dx*dx + dy*dy);
      
      if (distance > speed) {
        x += (dx / distance) * speed;
        y += (dy / distance) * speed;
      } else {
        active = false;
      }
    }
  }
  
  void draw() {
    if (active) {
      stroke(attackColor);
      strokeWeight(3);
      line(x, y, targetX, targetY);
    }
  }
  
  boolean checkHit(float px, float py, float pSize) {
    if (!active) return false;
    return dist(x, y, px, py) < pSize + 10;
  }
}

class BoneAttack {
  float x, y, vx, vy;
  boolean active = true;
  float size = 15;
  
  BoneAttack(float startX, float startY, float velX, float velY) {
    x = startX;
    y = startY;
    vx = velX;
    vy = velY;
  }
  
  void update() {
    if (active) {
      x += vx;
      y += vy;
      
      if (x < 0 || x > width || y < 0 || y > height) {
        active = false;
      }
    }
  }
  
  void draw() {
    if (active) {
      fill(sansYellow);
      noStroke();
      rect(x - size/2, y - size/2, size, size);
    }
  }
  
  boolean checkHit(float px, float py, float pSize) {
    if (!active) return false;
    return dist(x, y, px, py) < pSize + size/2;
  }
}

void setup() {
  size(800, 400);
  strokeWeight(2);
  background(0);
  
  lightSprite = makeLightSprite(256, 0.95);
}

void draw() {
  pushMatrix();
  cameraShakeX = random(-shakeIntensity, shakeIntensity);
  cameraShakeY = random(-shakeIntensity, shakeIntensity);
  translate(cameraShakeX, cameraShakeY);
  
  background(12);
  
  if (!gameOver) {
    drawSubtleScene();
    
    handlePlayerMovement();
    
    updateBossAttacks();
    updateWarnings();
    updateParticles();
    updateLighting();
    updateScreenEffects();
    updateBossAnimation();
    updateIsabellaMovement();
    updateYellowBalls();
    updateMinions();
    updateMeteors();
    updateBossRegen();
    updateAiming();
    
    drawPlayer();
    drawBoss();
    drawAttacks();
    drawWarnings();
    drawParticles();
    drawYellowBalls();
    drawMinions();
    drawMeteors();
    drawAiming();
    
    applyLighting();
    
    checkCollisions();
    
    updatePhase();
    
    drawUI();
    
  } else {
    drawGameOver();
  }
  
  popMatrix();
  
  drawScreenEffects();
}

void handlePlayerMovement() {
  float targetX = mouseX;
  float targetY = mouseY;
  
  float dx = targetX - playerX;
  float dy = targetY - playerY;
  float distance = sqrt(dx*dx + dy*dy);
  
  if (distance > 0) {
    playerX += (dx / distance) * playerSpeed;
    playerY += (dy / distance) * playerSpeed;
  }
  
  playerX = constrain(playerX, playerSize/2, width - playerSize/2);
  playerY = constrain(playerY, playerSize/2, height - playerSize/2);
  
  if (playerAttackCooldown > 0) {
    playerAttackCooldown--;
  } else {
    canAttack = true;
  }
}

void updateBossAttacks() {
  bossAttackTimer++;
  
  if (bossAttackTimer >= bossAttackCooldown) {
    bossIsCharging = true;
    bossAttackTimer = 0;
    
    if (bossPhase == 1) {
      createAttack();
    } else if (bossPhase == 2) {
      if (random(1) < 0.5) {
        createLightningPattern();
      } else {
        createBonePattern();
      }
    } else if (bossPhase == 3) {
      int pattern = (int)random(3);
      if (pattern == 0) {
        createLightningBarrage();
      } else if (pattern == 1) {
        createBoneBarrage();
      } else {
        createMixedPattern();
      }
    }
  }
  
  for (int i = attacks.size() - 1; i >= 0; i--) {
    LightningAttack attack = attacks.get(i);
    attack.update();
    if (!attack.active) {
      attacks.remove(i);
    }
  }
  
  for (int i = bones.size() - 1; i >= 0; i--) {
    BoneAttack bone = bones.get(i);
    bone.update();
    if (!bone.active) {
      bones.remove(i);
    }
  }
}

void createAttack() {
  if (bossPhase == 1) {
    float targetX = playerX + random(-50, 50);
    float targetY = playerY + random(-50, 50);
    warnings.add(new Warning(targetX, targetY, 60, warningDuration, color(255, 100, 100), "LIGHTNING"));
    createRandomWalkLightning(width, random(50, height-50), targetX, targetY, sansBlue);
  } else if (bossPhase == 2) {
    if (random(1) < 0.3) {
      float targetX = playerX + random(-30, 30);
      float targetY = playerY + random(-30, 30);
      warnings.add(new Warning(targetX, targetY, 50, warningDuration, color(255, 100, 100), "LIGHTNING"));
      createRandomWalkLightning(width, random(50, height-50), targetX, targetY, sansBlue);
    } else if (random(1) < 0.5) {
      float boneX = width;
      float boneY = random(50, height-50);
      warnings.add(new Warning(boneX, boneY, 40, warningDuration, color(255, 255, 0), "BONE"));
      bones.add(new BoneAttack(boneX, boneY, -3, random(-2, 2)));
    } else if (random(1) < 0.7) {
      yellowBalls.add(new YellowBall(isabellaX, isabellaY));
    } else {
      minions.add(new Minion(isabellaX + random(-100, 100), isabellaY + random(-100, 100)));
    }
  } else if (bossPhase == 3) {
    if (random(1) < 0.2) {
      for (int i = 0; i < 3; i++) {
        float targetX = playerX + random(-40, 40);
        float targetY = playerY + random(-40, 40);
        warnings.add(new Warning(targetX, targetY, 45, warningDuration, color(255, 100, 100), "LIGHTNING"));
        createRandomWalkLightning(width, random(50, height-50), targetX, targetY, sansBlue);
      }
    } else if (random(1) < 0.4) {
      for (int i = 0; i < 5; i++) {
        float boneX = width;
        float boneY = random(50, height-50);
        warnings.add(new Warning(boneX, boneY, 35, warningDuration, color(255, 255, 0), "BONE"));
        bones.add(new BoneAttack(boneX, boneY, -4, random(-3, 3)));
      }
    } else if (random(1) < 0.6) {
      for (int i = 0; i < 3; i++) {
        yellowBalls.add(new YellowBall(isabellaX + random(-50, 50), isabellaY + random(-50, 50)));
      }
    } else if (random(1) < 0.8) {
      for (int i = 0; i < 2; i++) {
        minions.add(new Minion(isabellaX + random(-150, 150), isabellaY + random(-150, 150)));
      }
    } else {
      for (int i = 0; i < 3; i++) {
        meteors.add(new Meteor(random(100, width-100), -50));
      }
    }
  }
}

void createRandomWalkLightning(float startX, float startY, float targetX, float targetY, color lightningColor) {
  stroke(lightningColor);
  strokeWeight(3);
  
  int tempStartX = (int)startX;
  int tempStartY = (int)startY;
  int tempEndX = tempStartX;
  int tempEndY = tempStartY;
  
  while (tempEndX > targetX) {
    tempEndX = tempStartX - (int)random(1, 10);
    tempEndY = tempStartY + (int)random(-9, 10);
    line(tempStartX, tempStartY, tempEndX, tempEndY);
    tempStartX = tempEndX;
    tempStartY = tempEndY;
  }
}

void drawPlayer() {
  fill(playerColor);
  noStroke();
  ellipse(playerX, playerY, playerSize, playerSize);
  
  fill(255, 0, 0);
  rect(playerX - 20, playerY - 30, 40, 6);
  fill(0, 255, 0);
  rect(playerX - 20, playerY - 30, 40 * (float)playerHealth / maxHealth, 6);
  
  fill(255);
  textAlign(CENTER);
  textSize(10);
  text(playerHealth + "/" + maxHealth, playerX, playerY - 35);
  
  if (!canAttack) {
    fill(255, 255, 0, 100);
    ellipse(playerX, playerY, playerSize + 10, playerSize + 10);
  }
  
  stroke(255);
  strokeWeight(1);
  line(mouseX - 5, mouseY, mouseX + 5, mouseY);
  line(mouseX, mouseY - 5, mouseX, mouseY + 5);
}


void drawAttacks() {
  for (LightningAttack attack : attacks) {
    attack.draw();
  }
  
  for (BoneAttack bone : bones) {
    bone.draw();
  }
}


void updatePhase() {
  phaseTimer++;
  
  if (phaseTimer >= phaseDuration) {
    bossPhase++;
    phaseTimer = 0;
    bossAttackCooldown = max(20, bossAttackCooldown - 10);
    
    if (bossPhase == 2) {
      phaseMessage = "Phase 2: Lightning + Bone Attacks!";
    } else if (bossPhase == 3) {
      phaseMessage = "Phase 3: INTENSE PATTERNS!";
    } else if (bossPhase > 3) {
      gameOver = true;
      playerWon = true;
    }
  }
}

void drawUI() {
  fill(255);
  textAlign(LEFT);
  text("Player Health: " + playerHealth, 20, 30);
  text("Boss Health: " + bossHealth, 20, 50);
  text("Phase: " + bossPhase, 20, 70);
  text("Time in Phase: " + (phaseDuration - phaseTimer)/60, 20, 90);
  
  if (canAttack) {
    text("Click to attack!", 20, 110);
  } else {
    text("Attack cooldown: " + playerAttackCooldown, 20, 110);
  }
  
  textAlign(CENTER);
  text(phaseMessage, width/2, height - 40);
  text(gameMessage, width/2, height - 20);
}

void drawGameOver() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(32);
  
  if (playerWon) {
    text("YOU WIN!", width/2, height/2);
    text("You defeated Isabella!", width/2, height/2 + 40);
  } else {
    text("GAME OVER", width/2, height/2);
    text("Isabella got you!", width/2, height/2 + 40);
  }
  
  textSize(16);
  text("Press R to restart", width/2, height/2 + 80);
}

void mousePressed() {
  startX = 0;
  startY = 150;
  endX = 0;
  endY = 150;
  
  if (canAttack && !gameOver && isAimingAtBoss) {
    attackBoss();
    playerAttackCooldown = maxPlayerAttackCooldown;
    canAttack = false;
    
    addCameraShake(3);
    addScreenFlash(color(255, 255, 0), 0.2);
    createHitParticles(playerX, playerY, color(255, 255, 0));
  }
  
  boost = 1.6;
}

void attackBoss() {
  float targetX = mouseX;
  float targetY = mouseY;
  
  stroke(sansYellow);
  strokeWeight(4);
  
  int tempStartX = (int)playerX;
  int tempStartY = (int)playerY;
  int tempEndX = tempStartX;
  int tempEndY = tempStartY;
  
  while (tempEndX < targetX) {
    tempEndX = tempStartX + (int)random(1, 10);
    tempEndY = tempStartY + (int)random(-9, 10);
    line(tempStartX, tempStartY, tempEndX, tempEndY);
    tempStartX = tempEndX;
    tempStartY = tempEndY;
  }
  
  if (dist(tempEndX, tempEndY, isabellaX, isabellaY) < 30) {
    bossHealth -= 20;
    if (bossHealth <= 0) {
      bossHealth = 0;
      if (bossPhase >= 3) {
        gameOver = true;
        playerWon = true;
        addCameraShake(20);
        addScreenFlash(color(0, 255, 0), 1.0);
      } else {
        advancePhase();
      }
    } else {
      addCameraShake(4);
      createHitParticles(isabellaX, isabellaY, color(255, 255, 0));
    }
  }
}

void advancePhase() {
  bossPhase++;
  bossHealth = maxBossHealth;
  phaseTimer = 0;
  bossRegenTimer = 0;
  
  attacks.clear();
  bones.clear();
  yellowBalls.clear();
  warnings.clear();
  minions.clear();
  meteors.clear();
  
  if (bossPhase == 2) {
    phaseMessage = "Phase 2: Minions and Yellow Balls!";
    gameMessage = "ISABELLA SUMMONS MINIONS! Aim and attack!";
  } else if (bossPhase == 3) {
    phaseMessage = "Phase 3: METEORS AND CHAOS!";
    gameMessage = "FINAL PHASE! Meteors and all attacks!";
  }
  
  addCameraShake(10);
  addScreenFlash(color(255, 255, 255), 0.5);
  
  if (bossPhase >= 2) {
    for (int i = 0; i < 3; i++) {
      minions.add(new Minion(isabellaX + random(-200, 200), isabellaY + random(-200, 200)));
    }
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    restartGame();
  }
}

void restartGame() {
  playerX = 100;
  playerY = 200;
  playerHealth = 100;
  bossPhase = 1;
  bossHealth = 300;
  bossAttackTimer = 0;
  bossAttackCooldown = 60;
  phaseTimer = 0;
  gameActive = true;
  gameOver = false;
  playerWon = false;
  gameMessage = "ISABELLA APPEARS! Move mouse to dodge, click to attack!";
  phaseMessage = "Phase 1: Basic Lightning Strikes";
  
  isabellaX = 700;
  isabellaY = 200;
  isabellaTargetX = 700;
  isabellaTargetY = 200;
  isabellaMoveTimer = 0;
  
  playerAttackCooldown = 0;
  canAttack = true;
  
  attacks.clear();
  bones.clear();
  yellowBalls.clear();
  warnings.clear();
  particles.clear();
  minions.clear();
  meteors.clear();
  
  shakeIntensity = 0;
  screenFlash = 0;
  bossIsCharging = false;
  bossAttackCharge = 0;
  
  startX = 0;
  startY = 150;
  endX = 0;
  endY = 150;
}

void updateLighting() {
  posX += (playerX - posX) * followSpeed;
  posY += (playerY - posY) * followSpeed;
  
  boost = lerp(boost, 1.0, 0.12);
}

void applyLighting() {
  float t = millis() * 0.001;
  int c1 = color(
    constrain(baseR + 30 * sin(t * 0.8), 0, 255),
    constrain(baseG + 20 * sin(t * 0.7 + 1.3), 0, 255),
    constrain(baseB + 15 * sin(t * 0.6 + 2.1), 0, 255)
  );

  drawLight(posX, posY, c1, lightRadius * boost);
}

void drawLight(float x, float y, int c, float radius) {
  pushMatrix();
  translate(x, y);
  float s = (radius * 2.0) / lightSprite.width;
  scale(s, s);
  tint(red(c), green(c), blue(c), 100);
  imageMode(CENTER);
  image(lightSprite, 0, 0);
  popMatrix();
}

PGraphics makeLightSprite(int size, float fillFrac) {
  PGraphics pg = createGraphics(size, size);
  pg.beginDraw();
  pg.loadPixels();
  int w = pg.width;
  int h = pg.height;
  float cx = (w - 1) * 0.5;
  float cy = (h - 1) * 0.5;
  float maxR = min(cx, cy) * fillFrac;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float dx = x - cx;
      float dy = y - cy;
      float d = sqrt(dx * dx + dy * dy);
      float a = 1.0 - constrain(d / maxR, 0, 1);
      a = a * a;
      int alpha = (int)(a * 255);
      pg.pixels[y * w + x] = color(255, 255, 255, alpha);
    }
  }
  pg.updatePixels();
  pg.endDraw();
  return pg;
}

void drawSubtleScene() {
  stroke(40);
  strokeWeight(1);
  for (int x = 0; x <= width; x += 20) line(x, 0, x, height);
  for (int y = 0; y <= height; y += 20) line(0, y, width, y);

  noStroke();
  fill(25); 
  rect(40, 60, 90, 280, 8);
  fill(30); 
  ellipse(300, 120, 110, 110);
  fill(22); 
  rect(230, 240, 130, 90, 10);
  
  fill(35);
  rect(width - 150, 50, 80, 300, 12);
  fill(28);
  ellipse(150, height - 100, 120, 80);
}

void updateWarnings() {
  for (int i = warnings.size() - 1; i >= 0; i--) {
    Warning warning = warnings.get(i);
    warning.update();
    if (!warning.isActive()) {
      warnings.remove(i);
    }
  }
}

void updateParticles() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle particle = particles.get(i);
    particle.update();
    if (particle.isDead()) {
      particles.remove(i);
    }
  }
}

void updateScreenEffects() {
  shakeIntensity *= shakeDecay;
  if (shakeIntensity < 0.1) shakeIntensity = 0;
  
  screenFlash *= screenFlashDecay;
  if (screenFlash < 0.1) screenFlash = 0;
}

void updateBossAnimation() {
  bossAnimationTimer++;
  if (bossIsCharging) {
    bossAttackCharge += 0.1;
    if (bossAttackCharge >= 1.0) {
      bossAttackCharge = 0;
      bossIsCharging = false;
    }
  }
}

void drawWarnings() {
  for (Warning warning : warnings) {
    warning.draw();
  }
}

void drawParticles() {
  for (Particle particle : particles) {
    particle.draw();
  }
}

void drawScreenEffects() {
  if (screenFlash > 0) {
    fill(red(flashColor), green(flashColor), blue(flashColor), screenFlash * 100);
    rect(0, 0, width, height);
  }
}

void checkCollisions() {
  for (LightningAttack attack : attacks) {
    if (attack.checkHit(playerX, playerY, playerSize)) {
      playerHealth -= 10;
      attack.active = false;
      addCameraShake(5);
      addScreenFlash(color(255, 0, 0), 0.3);
      createHitParticles(playerX, playerY, color(255, 100, 100));
    }
  }
  
  for (BoneAttack bone : bones) {
    if (bone.checkHit(playerX, playerY, playerSize)) {
      playerHealth -= 15;
      bone.active = false;
      addCameraShake(8);
      addScreenFlash(color(255, 255, 0), 0.4);
      createHitParticles(playerX, playerY, color(255, 255, 0));
    }
  }
  
  for (YellowBall ball : yellowBalls) {
    if (ball.checkHit(playerX, playerY, playerSize)) {
      playerHealth -= ball.damage;
      ball.active = false;
      addCameraShake(3);
      addScreenFlash(color(255, 255, 0), 0.2);
      createHitParticles(playerX, playerY, color(255, 255, 0));
    }
  }
  
  for (Minion minion : minions) {
    if (minion.checkHit(playerX, playerY, playerSize)) {
      playerHealth -= 10;
      addCameraShake(4);
      addScreenFlash(color(255, 0, 0), 0.3);
      createHitParticles(playerX, playerY, color(255, 0, 0));
    }
  }
  
  for (Meteor meteor : meteors) {
    if (meteor.checkHit(playerX, playerY, playerSize)) {
      playerHealth -= meteor.damage;
      meteor.active = false;
      addCameraShake(8);
      addScreenFlash(color(255, 100, 0), 0.6);
      createHitParticles(playerX, playerY, color(255, 100, 0));
    }
  }
  
  if (playerHealth <= 0) {
    gameOver = true;
    playerWon = false;
    addCameraShake(15);
    addScreenFlash(color(255, 0, 0), 0.8);
  }
}

void addCameraShake(float intensity) {
  shakeIntensity = max(shakeIntensity, intensity);
}

void addScreenFlash(color c, float intensity) {
  screenFlash = max(screenFlash, intensity);
  flashColor = c;
}

void createHitParticles(float x, float y, color c) {
  for (int i = 0; i < 8; i++) {
    float angle = random(TWO_PI);
    float speed = random(2, 6);
    particles.add(new Particle(
      x, y,
      cos(angle) * speed,
      sin(angle) * speed,
      random(20, 40),
      c,
      random(3, 8)
    ));
  }
}

void drawBoss() {
  if (bossIsCharging) {
    fill(sansBlue, bossAttackCharge * 100);
    noStroke();
    ellipse(isabellaX, isabellaY, 60 + bossAttackCharge * 20, 60 + bossAttackCharge * 20);
  }
  
  fill(sansBlue);
  noStroke();
  float bobOffset = sin(bossAnimationTimer * 0.1) * 3;
  ellipse(isabellaX, isabellaY + bobOffset, 40, 40);
  
  fill(255, 0, 0);
  rect(isabellaX - 30, isabellaY - 50, 60, 8);
  fill(0, 255, 0);
  rect(isabellaX - 30, isabellaY - 50, 60 * (float)bossHealth / maxBossHealth, 8);
  
  fill(255);
  textAlign(CENTER);
  textSize(10);
  text(bossHealth + "/" + maxBossHealth, isabellaX, isabellaY - 55);
  
  textSize(12);
  text("ISABELLA", isabellaX, isabellaY - 65);
  text("PHASE " + bossPhase, isabellaX, isabellaY - 75);
  
  if (bossHealth < maxBossHealth * 0.3) {
    fill(255, 0, 0, 100);
    rect(isabellaX - 30, isabellaY - 50, 60, 8);
  }
}

void updateIsabellaMovement() {
  isabellaMoveTimer++;
  
  if (isabellaMoveTimer >= isabellaMoveCooldown) {
    isabellaTargetX = random(200, width - 100);
    isabellaTargetY = random(100, height - 100);
    isabellaMoveTimer = 0;
  }
  
  float dx = isabellaTargetX - isabellaX;
  float dy = isabellaTargetY - isabellaY;
  float distance = sqrt(dx*dx + dy*dy);
  
  if (distance > 0) {
    isabellaX += (dx / distance) * isabellaSpeed;
    isabellaY += (dy / distance) * isabellaSpeed;
  }
}

void updateYellowBalls() {
  for (int i = yellowBalls.size() - 1; i >= 0; i--) {
    YellowBall ball = yellowBalls.get(i);
    ball.update();
    if (!ball.active) {
      yellowBalls.remove(i);
    }
  }
}

void drawYellowBalls() {
  for (YellowBall ball : yellowBalls) {
    ball.draw();
  }
}

void updateMinions() {
  for (int i = minions.size() - 1; i >= 0; i--) {
    Minion minion = minions.get(i);
    minion.update();
    if (!minion.active) {
      minions.remove(i);
    }
  }
}

void updateMeteors() {
  for (int i = meteors.size() - 1; i >= 0; i--) {
    Meteor meteor = meteors.get(i);
    meteor.update();
    if (!meteor.active) {
      meteors.remove(i);
    }
  }
}

void updateBossRegen() {
  bossRegenTimer++;
  if (bossRegenTimer >= bossRegenCooldown && bossHealth < maxBossHealth) {
    bossHealth = min(maxBossHealth, bossHealth + bossRegenAmount);
    bossRegenTimer = 0;
  }
}

void updateAiming() {
  float distance = dist(mouseX, mouseY, isabellaX, isabellaY);
  isAimingAtBoss = distance < aimDistance;
}

void drawMinions() {
  for (Minion minion : minions) {
    minion.draw();
  }
}

void drawMeteors() {
  for (Meteor meteor : meteors) {
    meteor.draw();
  }
}

void drawAiming() {
  stroke(255);
  strokeWeight(2);
  line(mouseX - 10, mouseY, mouseX + 10, mouseY);
  line(mouseX, mouseY - 10, mouseX, mouseY + 10);
  
  if (isAimingAtBoss) {
    stroke(0, 255, 0);
    strokeWeight(3);
    ellipse(mouseX, mouseY, 20, 20);
    fill(0, 255, 0, 100);
    noStroke();
    ellipse(mouseX, mouseY, 15, 15);
  } else {
    stroke(255, 0, 0);
    strokeWeight(2);
    ellipse(mouseX, mouseY, 15, 15);
  }
}

void createLightningPattern() {
  float centerX = playerX;
  float centerY = playerY;
  
  warnings.add(new Warning(centerX - 80, centerY, 40, warningDuration, color(255, 100, 100), "LIGHTNING"));
  warnings.add(new Warning(centerX + 80, centerY, 40, warningDuration, color(255, 100, 100), "LIGHTNING"));
  createRandomWalkLightning(width, centerY, centerX - 80, centerY, sansBlue);
  createRandomWalkLightning(width, centerY, centerX + 80, centerY, sansBlue);
  
  warnings.add(new Warning(centerX, centerY - 60, 40, warningDuration, color(255, 100, 100), "LIGHTNING"));
  warnings.add(new Warning(centerX, centerY + 60, 40, warningDuration, color(255, 100, 100), "LIGHTNING"));
  createRandomWalkLightning(width, centerY - 60, centerX, centerY - 60, sansBlue);
  createRandomWalkLightning(width, centerY + 60, centerX, centerY + 60, sansBlue);
}

void createBonePattern() {
  for (int i = 0; i < 8; i++) {
    float angle = (TWO_PI / 8) * i;
    float x = width + cos(angle) * 50;
    float y = height/2 + sin(angle) * 50;
    warnings.add(new Warning(x, y, 30, warningDuration, color(255, 255, 0), "BONE"));
    bones.add(new BoneAttack(x, y, -2, sin(angle) * 2));
  }
}

void createLightningBarrage() {
  for (int i = 0; i < 5; i++) {
    float targetX = playerX + random(-60, 60);
    float targetY = playerY + random(-60, 60);
    warnings.add(new Warning(targetX, targetY, 50, warningDuration, color(255, 100, 100), "LIGHTNING"));
    createRandomWalkLightning(width, random(50, height-50), targetX, targetY, sansBlue);
  }
}

void createBoneBarrage() {
  for (int i = 0; i < 10; i++) {
    float y = 50 + (height - 100) * i / 9;
    warnings.add(new Warning(width, y, 25, warningDuration, color(255, 255, 0), "BONE"));
    bones.add(new BoneAttack(width, y, -5, 0));
  }
}

void createMixedPattern() {
  for (int i = 0; i < 3; i++) {
    float targetX = playerX + random(-40, 40);
    float targetY = playerY + random(-40, 40);
    warnings.add(new Warning(targetX, targetY, 45, warningDuration, color(255, 100, 100), "LIGHTNING"));
    createRandomWalkLightning(width, random(50, height-50), targetX, targetY, sansBlue);
  }
  
  for (int i = 0; i < 6; i++) {
    float boneX = width;
    float boneY = random(50, height-50);
    warnings.add(new Warning(boneX, boneY, 30, warningDuration, color(255, 255, 0), "BONE"));
    bones.add(new BoneAttack(boneX, boneY, -4, random(-2, 2)));
  }
}
