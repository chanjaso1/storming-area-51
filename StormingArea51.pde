//Storming Area 51
//Final Project for CGRA151
//Tower defense game based on the controversy of "Storming Area 51"
//By: Jason Chan
//Last updated: 05/10/2019
//Date created: 23/08/2019

ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Tower> units = new ArrayList<Tower>();
int images = 5;
PImage[] image = new PImage[images];
int frames = 0;  

Level currentLevel = new Level(0);
float[] coords = currentLevel.getCoords();
float[] coordsPath2;
int playerHealth;
int money;       
int round, highestScore1 = 0, highestScore2 = 0, highScore = 0;
int enemiesKilled, totalKilled, totalSpent;
int level = currentLevel.getLevel();
boolean lost = false, newScore = false;
boolean buildMode = false, pause = false;

PImage rocket;
PImage machineGunHead;
PImage rocketHead;
PImage rocketHeadLoaded;
PImage autoLauncher;
PImage muzzleFire;
PImage turretFloor;
PImage turretFloor2;
PImage turretFloor3;


PImage runner1;
PImage runner2;
PImage runner3;
PImage runnerLeg;
PImage runnerLeg2;

PImage basic1;
PImage basic2;
PImage basic3;
PImage basicLeg;
PImage basicLeg2;

PImage tank;
PImage taLegs;    

PImage menuButton;
PImage menuButtonPressed;
PImage pauseButton;
PImage playButton;
PImage panel;
PImage background;
PImage desertBush;
PImage stone;
PImage stoneLarge;
PFont font;

String name = "";

void setup() {
  size(1000, 700);
  frameRate(60);
  font  = createFont("gunplay rg.ttf", 20);
  textFont(font);

  machineGunHead = loadImage("towerDefense_tile249.png");
  muzzleFire = loadImage("towerDefense_tile295.png");
  turretFloor = loadImage("towerDefense_tile181.png");

  rocket = loadImage("towerDefense_tile252.png");
  rocketHead = loadImage("towerDefense_tile229.png");
  rocketHeadLoaded = loadImage("towerDefense_tile206.png");
  turretFloor2 = loadImage("towerDefense_tile182.png");

  autoLauncher = loadImage("towerDefense_tile250.png");
  turretFloor3 = loadImage("towerDefense_tile180.png");

  image[0] = loadImage("explosion1.png");
  image[1] = loadImage("explosion2.png");
  image[2] = loadImage("explosion2.png");
  image[3] = loadImage("explosion4.png");  
  image[4] = loadImage("explosion5.png");


  basic1 = loadImage("characterGreen (1).png");
  basic2 = loadImage("characterGreen (8).png");
  basic3 = loadImage("characterGreen (4).png");
  basicLeg = loadImage("characterGreen (13).png");
  basicLeg2 = loadImage("characterGreen (14).png");

  runner1 = loadImage("characterRed (10).png");
  runner2 = loadImage("characterRed (4).png");
  runner3 = loadImage("characterRed (7).png");
  runnerLeg = loadImage("characterRed (13).png");
  runnerLeg2 = loadImage("characterRed (14).png");

  tank = loadImage("manBrown_hold.png");

  menuButton = loadImage("buttonLong_brown.png");
  menuButtonPressed = loadImage("buttonLong_brown_pressed.png");
  pauseButton = loadImage("pause.png");
  playButton = loadImage("right.png");
  panel = loadImage("panelInset_brown.png");
  background = loadImage("edited.jpg");
  desertBush = loadImage("towerDefense_tile134.png");
  stone = loadImage("towerDefense_tile135.png");
  stoneLarge = loadImage("towerDefense_tile136.png");
}


void draw() {
  coords = currentLevel.getCoords();

  level = currentLevel.getLevel();
  currentLevel.reDrawEverything();

  if (!pause) {  
    if (level != 0 && !units.isEmpty() && enemies.size() < 5 + (10 * (round - 1)) && !lost) {    //handles all the spawning for all the enemy types
      if (Math.random() <  0.007 + (0.0005 * (round -1))) {    //spawn an enemy if conditions are true
        enemies.add(new Enemy("basic"));
      } else if (Math.random() < 0.003 + (0.0002 * (round - 1))) {
        enemies.add(new Enemy("runner"));
      } else if (round >= 5 && Math.random() < 0.0007 + (0.0002 * (round - 1))) {
        enemies.add(new Enemy("tank"));
      } 
      if (enemiesKilled % 12 == 0 && enemiesKilled != 0) {      //next round if enough enemies are killed
        round ++;
        enemiesKilled = 0;
      }
    }
  }

  //---------------------------------------------------------------------------------------

  if (level != 0 && level != -1) {
    if (mousePressed && !buildMode) {//allow user to select a tower in the in-game user interface
      if (mouseX > 710 && mouseX < 845 && mouseY > 210 && mouseY < 350) {
        buildMode = true;
        name = "Machine Gunner";
      } else if (mouseX > 855 && mouseX < 990 & mouseY > 210 && mouseY < 350) {
        buildMode = true;
        name = "Rocket Launcher";
      } else if (mouseX > 710 && mouseX < 845 && mouseY > 360 && mouseY < 500) {
        buildMode = true;
        name = "Auto Launcher";
      }
    }
  }

  Tower t = new Tower(name);
  if (mouseX < 700 && mousePressed && get(mouseX, mouseY)  == color(242, 209, 107) && t.getCost() <= money && buildMode) { //if conditions are true, allow user to buy
    buildMode = false;
    t.buy();
    units.add(t);        //add tower to the tower list
  }
  if (keyPressed) {
    if (keyPressed && key == 'e' && buildMode) {
      buildMode = false;
    }
  }
  //---------------------------------------------------------------------------------------

  if (buildMode) {            //handles graphics for buying towers
    fill(100, 100, 100, 127);
    textSize(25);
    if (t.getCost() > money) {          
      fill(139, 0, 0);
      text("You do not have enough money!", 175, 600);
    }
    if (get(mouseX, mouseY) != color(242, 209, 107) || t.getCost() > money)  fill(139, 0, 0, 127);

    noStroke();
    ellipse(mouseX, mouseY, t.getRange() * 2, t.getRange() * 2);    //draw the range
    if (name.equals("Machine Gunner")) {                            //draw tower
      image(turretFloor, mouseX - 30, mouseY - 30, 60, 60);
      image(machineGunHead, mouseX - 30, mouseY - 30, 60, 60);
    } else if (name.equals("Rocket Launcher")) {
      image(turretFloor2, mouseX - 30, mouseY - 30, 60, 60);
      image(rocketHeadLoaded, mouseX - 30, mouseY - 30, 60, 60 );
    } else if (name.equals("Auto Launcher")) {
      image(turretFloor3, mouseX - 40, mouseY - 40, 80, 80);
      image(autoLauncher, mouseX - 40, mouseY - 40, 80, 80 );
    }

    fill(0);
    text("Press E to Cancel", 250, 650);
  }
}
