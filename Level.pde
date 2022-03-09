public class Level {
  public float[] coords;
  public float[]  bush;
  public float[]  stones;
  public float[]  largeStones;
  public int level;
  public float YLostBox = 1000;
  public Level(int level) {
    changeLevel(level);
  }

  /**
   Draw all towers, enemies and background repeatedly. This is the main drawing method for all levels, the title screen, and About screen.
   Returns nothing
   */
  public void reDrawEverything() {
    if (level != 0 && level != -1) {
      background(242, 209, 107);

      strokeWeight(30);
      stroke(147, 154, 160);
      noFill();

      beginShape();
      for (int i = 0; i < coords.length; i += 2) {   //draw first path
        curveVertex(coords[i], coords[i +1]);
      }
      endShape();
      if (level == 2) {  //if second level, draw 2nd path
        beginShape();
        for (int k = 0; k < coordsPath2.length; k += 2) {
          curveVertex(coordsPath2[k], coordsPath2[k+1]);
        }
        endShape();
      }


      for (int enemy = 0; enemy < enemies.size(); enemy++) {  //draw all enemies
        if (!enemies.get(enemy).follow()) {
          enemies.remove(enemy);            //remove enemy if it has completed its route
        }
      }    

      for (int j = 0; j < stones.length; j += 2) {
        translate(stones[j], stones[j+1]);
        image(stone, 0, 0);
        resetMatrix();
      }
      for (int k = 0; k < largeStones.length; k += 2) {
        translate(largeStones[k], largeStones[k+1]);
        image(stoneLarge, 0, 0);
        resetMatrix();
      }

      for (int tower = 0; tower < units.size(); tower++) {    //draw all towers
        units.get(tower).drawTower();
      }


      fill(110, 90, 60);
      stroke(0);
      strokeWeight(1);

      //draw the buy panel, displays turrets and their cost 
      rect(700, 0, 300, 700);
      fill(140);
      fill(165, 128, 80);
      rect(710, 10, 280, 60);    //first box for health and money


      image(menuButton, 710, 110, 135, 60);  //menu button for pause
      image(menuButton, 855, 110, 135, 60);  //menu button for play  
      image(pauseButton, 780-25, 139-25, 50, 50);
      image(playButton, 925-25, 139-25, 50, 50);

      if (pause) {
        image(menuButtonPressed, 710, 110, 135, 60);  
        image(pauseButton, 780-25, 142-25, 50, 50);
      } else {
        image(menuButtonPressed, 855, 110, 135, 60);  
        image(playButton, 925-25, 142-25, 50, 50);
      }

      image(panel, 710, 180, 135, 140);  //first panel
      image(panel, 855, 180, 135, 140);  //second panel
      image(panel, 710, 325, 135, 140);  //third panel

      image(menuButton, 710, 640, 135, 50);  //quit panel
      image(menuButton, 855, 640, 135, 50);  //retry panel

      fill(0);
      textSize(11);  

      //draw Machine Gun Turret
      image(turretFloor, 777.5-30, 220-30);
      image(machineGunHead, 777.5-30, 220-30);

      text("Cost: $40", 720, 270);
      text("Single target\nLow damage", 720, 290);

      //draw Rocket launcher
      image(turretFloor2, 920-30, 220-30);
      image(rocketHeadLoaded, 920-30, 220-30);

      text("Cost: $60", 870, 270);
      text("Single target\nHigh damage", 870, 290);

      //draw Auto Launcher
      image(turretFloor2, 785.5-40, 380-40);
      image(autoLauncher, 785.5-40, 380-40);

      text("Cost: $100", 720, 420);
      text("Splash damage\nModerate damage", 720, 440);

      textSize(20);
      text("Menu", 753, 670);
      text("Retry", 897, 670);
      textSize(30);
      text("HEALTH: " + playerHealth, 820, 50);
      text("$" + money, 720, 50 );
      text("Round: " + round, 555, 40);

      for (int i = 0; i  < bush.length; i += 2) {
        translate(bush[i], bush[i +1]);
        image(desertBush, 0, 0);
        resetMatrix();
      }
      //---------------------------------------------------------------------------------------
      if (playerHealth  <= 0) {     //if the player loses, a lose menu will appear      
        strokeWeight(1);
        stroke(0);
        fill(165, 128, 80);
        rect(150, 100, 400, 300);
        textSize(35);
        fill(139, 0, 0);
        text("You have failed!", 225, 150);  
        fill(0);
        textSize(20);
        if (!lost) {
          highScore = 2 * (money + totalKilled + totalSpent + units.size()) + 10 * (round);      //calcuate current score
          lost = true;  //calculate score once per loss
        }
        text("Current Score: " + highScore, 175, 205);
        if ((highScore > highestScore1 &&  level == 1) || (highScore > highestScore2 && level == 2))  newScore = true;

        if (level == 1) {
          if (newScore) {
            highestScore1 = highScore;
            text("New high score: " + highestScore1, 175, 180);
          } else   text("High score: " + highestScore1, 175, 180);
        } else if (level == 2) {
          if (newScore) {
            highestScore2 = highScore;
            text("New high score: " + highestScore2, 175, 180);
          } else   text("High score: " + highestScore2, 175, 180);
        }
        text("Total enemies killed: " + totalKilled, 175, 230);
        text("Number of towers: " + units.size(), 175, 255);
        text("Total spent: $" + totalSpent, 175, 280);
        text("Area 51 has been stormed!", 225, 315);

        image(menuButton, 185, 330, 135, 50);  //menu button on lost screen
        image(menuButton, 375, 330, 135, 50);  //retry button on lost screen
        text("Menu", 225, 360);
        text("Retry", 420, 360);
        pause = true;
      }
      //---------------------------------------------------------------------------------------

      //in-game buttons when pressed 
      textSize(20);
      if (mousePressed) {
        if (mouseX > 710 && mouseX < 845 && mouseY > 640 && mouseY < 690) {      //go back to main menu
          image(menuButtonPressed, 710, 640, 135, 50);
          text("Menu", 753, 673);       
          reset();
          changeLevel(0);
        } else if (mouseX > 855 && mouseX < 990 && mouseY > 640 && mouseY < 690) {
          image(menuButtonPressed, 855, 640, 135, 50);
          text("Retry", 897, 673);
          reset();
        } else if (mouseX > 710 && mouseX < 850 && mouseY > 110 && mouseY < 170) {
          pause = true;
        } else if (mouseX > 850 && mouseX < 990 && mouseY > 110 && mouseY < 170) {
          pause = false;
        } else if (lost) {  
          if (mouseX > 185 && mouseX < 320 && mouseY > 330 && mouseY < 385) {
            image(menuButtonPressed, 185, 330, 135, 50); 
            text("Menu", 225, 362);
            changeLevel(0);
          } else if (mouseX > 375 && mouseX < 510 && mouseY > 330 && mouseY < 385) {
            image(menuButtonPressed, 185, 330, 135, 50); 
            text("Retry", 420, 362);
            reset();
          }
        }
      }
      //---------------------------------------------------------------------------------------
    } else if (level == -1) {      //about screen for how to play the game, what is it and other information
      image(background, 0, 0, 1000, 700);
      fill(165, 128, 80);
      rect(150, 150, 600, 500);  
      fill(0);    
      strokeWeight(2);   
      textSize(20);
      text("What is \"Storming Area 51\"?", 170, 180);
      text("How to play: ", 170, 310);
      image(menuButton, 600, 595, 135, 50);  //back to menu button
      text("Back", 640, 625);
      if (mouseX > 600 && mouseX < 735 && mouseY > 595 && mouseY < 645 && mousePressed) {  //check if user clicked on button
        image(menuButtonPressed, 600, 595, 135, 50);  
        text("Back", 640, 627);        
        changeLevel(0);  //switch back to menu
      }
      textSize(15);
      text("Storming Area 51 is a tower defence game based on the controversy of Area 51\nin September, 2019. The game will contain multiple levels which will contain a\nvariety of towers and enemies where the player will have to survive as long\nas they can before they are overrun.", 170, 205);
      text("Storming Area 51 was inspired by Bloons Tower Defense 5 and the tower defense\ngenre. All assets used follow the CC0 1.0 Universal Public Domain Dedication\nlicence.\nCreated by Jason Chan on 8th October, 2019.", 170, 555);
      text("-  Kill the enemies with using the towers!\n-  Click on a tower to go in to buy mode.\n-  Place the tower on the ground where there is free space to buy.\n-  The tower will automatically shoot an enemy within range.\n-  Make sure that you buy the best tower for the situation!\n-  Survive as long as you can!", 170, 335);
      //---------------------------------------------------------------------------------------
    } else {      //draw main menu
      image(background, 0, 0, 1000, 700);
      textSize(45);
      fill(0);
      text("Storming Area 51", 320, 250);
      image(menuButton, 280, 300, 200, 50);
      image(menuButton, 520, 300, 200, 50);
      image(menuButton, 400, 380, 200, 50);
      image(menuButton, 400, 440, 200, 50);

      textSize(30);
      text("Level 1", 330, 335);
      text("Level 2", 570, 335);
      text("About", 460, 415);
      text("Quit", 470, 475);

      //when buttons are pressed in the main menu
      if (mouseX > 280 && mouseX < 480 && mouseY > 300 && mouseY < 350 && mousePressed) {
        image(menuButtonPressed, 280, 300, 200, 50);
        text("Level 1", 330, 337);
        changeLevel(1);
      } else if (mouseX > 520 && mouseX < 720 && mouseY > 300 && mouseY < 350 && mousePressed) {
        image(menuButtonPressed, 520, 300, 200, 50);
        text("Level 2", 570, 337);
        changeLevel(2);
      } else if (mouseX > 400 && mouseX < 600 && mouseY > 380 && mouseY < 430 && mousePressed) {
        image(menuButtonPressed, 400, 380, 200, 50);
        text("About", 460, 417);
        changeLevel(-1);
      } else if (mouseX > 400 && mouseX < 600 && mouseY > 440 && mouseY < 490 && mousePressed) {
        image(menuButtonPressed, 400, 440, 200, 50);
        text("Quit", 470, 477);
        exit();
      }
    }
  }

  /**
   Get coordinates
   */
  public float[] getCoords() {
    return coords;
  }

  /**
   Get level
   */
  public int getLevel() {
    return level;
  }

  /**
   Changes level by re-defining coordinates for enemy path
   */
  public void changeLevel(int newLevel) {
    if (newLevel == 1) {
      coords = new float[]{175, 0, 175, 0, 175, 175, 450, 175, 450, 315, 70, 400, 100, 600, 550, 600, 575, 750, 575, 750};
      bush = new float[]{541, 530, 301, 90, 410, 200, 110, 180, 630, 550, 278, 260, 529, 407, 590, 371};
      stones = new float[]{136, 495};
      largeStones = new float[]{223, 447};
    } else if (newLevel == 2) {
      coords = new float[]{0, 66, 0, 66, 330, 80, 360, 400, 715, 430, 715, 430};
      coordsPath2 = new float[]{0, 630, 0, 630, 320, 600, 361, 250, 715, 220, 715, 220};
      bush= new float[]{488, 133, 560, 109, 495, 56, 509, 654, 620, 560, 86, 380, 525, 318, 174, 139, 216, 268, 159, 221, 75, 233, 487, 546 };
      stones = new float[]{205, 510, 237, 416};
      largeStones = new float[]{198, 453};
    }
    level = newLevel;
    reset();
  }
}

/** 
 Resets everything back to original
 */
public void reset() {
  units.clear();
  enemies.clear();
  money = 80;
  playerHealth = 15;
  round = 1;
  enemiesKilled = 0; 
  totalKilled = 0; 
  totalSpent = 0;
  newScore = false;
  lost = false;
  pause = false;
}
