public class Enemy {
  public int width;
  public int height;
  public PImage shape, leg;
  public float health, maxHealth;
  public float speed;
  public int reward;
  public float x, y;
  public String name;
  private float t;
  private float amplitude = 0.6, period = 40, switchLeg = -10, legX = amplitude * cos(TWO_PI * frameCount / period);    //oscillation movement for legs
  private int index, index2;
  private int damage;                 //Enemy damage to the player's health
  private float xTangent, yTangent;
  private boolean origin = true;      //first time calculation for the position of the object
  private boolean path2 = false;    //second path for enemy in level 2

  public Enemy(String name) {
    this.name = name;
    if (name == "basic") {      

      this.maxHealth = 6 + (1 * (round - 1));
      this.speed = 0.004;
      this.reward = 6;
      this.damage = 1;
      if (Math.random() < 0.33) {        //draw one of three skin colour types of basic enemies
        this.shape = basic1;
        this.leg = basicLeg;
      } else if (Math.random() < 0.66) { 
        this.shape = basic2;
        this.leg = basicLeg;
      } else if (Math.random() < 1) {  
        this.shape = basic3;
        this.leg = basicLeg2;
      }
    }
    if (name == "runner") {
      this.maxHealth = 4;
      this.speed = 0.01;
      this.reward = 7;
      this.damage = 1;
      if (Math.random() < 0.33) {        //draw one of three skin colour types of runner enemies
        this.shape = runner1;
        this.leg = runnerLeg;
      } else if (Math.random() < 0.66) { 
        this.shape = runner2;
        this.leg = basicLeg2;
      } else if (Math.random() < 1) {  
        this.shape = runner3;
        this.leg = runnerLeg;
      }
    }
    if (name == "tank") {
      this.maxHealth = 60 + (1 * (round - 1)); 
      this.speed = 0.0015;
      this.reward = 20;
      this.damage = 5;
      this.shape = tank;
      this.leg = runnerLeg;
    }
    this.health = maxHealth;
  }

//---------------------------------------------------------------------------------------

  /**
   Enemy takes damage, and if enemy has no health, it is removed from the enemies ArrayList
   */
  public void hit(float damage) {
    health -= damage;
    if (health <= 0) { 
      enemies.remove(this);
      money += reward;
      totalKilled ++;
      enemiesKilled ++;
    }
  }

  /**
   Redraw enemy as it follows the bezier path 
   Returns true or false if the enemy has completed its route or not
   */
  public boolean  follow() {
    legX = amplitude * cos(TWO_PI * frameCount / period);
    boolean ans = true;
    if (origin) {
      this.index = 0;
      origin = false;
      if (Math.random() < 0.5 && currentLevel.getLevel() == 2) {    //decide which path to use if level 2
        path2 = true;
      }
    }
    if (!path2) {//define x and y for paths in level 1 and 2
      this.x = curvePoint(coords[0 + this.index], coords[2 + this.index], coords[4 + this.index], coords[6 +  this.index], t );
      this.y = curvePoint(coords[1 + this.index], coords[3 + this.index], coords[5 + this.index], coords[7 +  this.index], t );
      this.xTangent = curveTangent( coords[0 + this.index], coords[2 + this.index], coords[4 + this.index], coords[6 +  this.index], t);
      this.yTangent = curveTangent(coords[1 + this.index], coords[3 + this.index], coords[5 + this.index], coords[7 +  this.index], t );
    } else {  //Only used in level 2 where there is a second path. Defines x and y for the second path in level 2
      this.x = curvePoint(coordsPath2[0 + this.index], coordsPath2[2 + this.index], coordsPath2[4 + this.index], coordsPath2[6 +  this.index], t );
      this.y = curvePoint(coordsPath2[1 + this.index], coordsPath2[3 + this.index], coordsPath2[5 + this.index], coordsPath2[7 +  this.index], t );
      this.xTangent = curveTangent( coordsPath2[0 + this.index], coordsPath2[2 + this.index], coordsPath2[4 + this.index], coordsPath2[6 +  this.index], t);
      this.yTangent = curveTangent(coordsPath2[1 + this.index], coordsPath2[3 + this.index], coordsPath2[5 + this.index], coordsPath2[7 +  this.index], t );
    }


    float angle = atan2( yTangent, xTangent) ;  //define rotation 
    translate(this.x, this.y);                  //move enemy

    stroke(0);              //draw health bar
    strokeWeight(1);
    noFill();
    rect(-15, 20, 30, 10);    
    fill(255, 0, 0);
    rect(-15, 20, 30, 10);  
    fill(3, 198, 0);
    rect(-15, 20, (health/maxHealth) * 30, 10);    //ratio of health and max health

    //leg movement

    if (!name.equals("tank")) {    //draw enemy WITH moving legs
      if(!pause){
      rotate(PI + angle);        
      image(leg, legX * 8, switchLeg, 10, 10);

      rotate(PI);
      image(leg, legX * 8, switchLeg, 10, 10);
      }
      resetMatrix();
      translate(x, y);
      rotate(angle);
      image(shape, -12, -12, 25, 25);
      resetMatrix();
      if (legX == -amplitude) {
        if (switchLeg == -10)  switchLeg = 0;    
        else                  switchLeg = -10;
      }
    } else {

      rotate(angle);    //draw the enemy WITHOUT moving legs
      image(shape, -25, -25, 50, 50);
      resetMatrix();
    }
    if (!pause)  t += speed;    //pause movement if it is true
    
    if (t > 1) {    
      t = 0;

      this.index += 2;
      if (index == 14 && level == 1 || (index == 6 && level == 2) || (index2 == 6 && level == 2)) {    //route is finished
        playerHealth -= this.damage;
        if (playerHealth < 0)   playerHealth = 0;    
        ans = false;  //redefine boolean to remove enemy from the list
      }
    }

    return ans;
  }
  
//---------------------------------------------------------------------------------------
  
  /**
   Return x coordinate of enemy
   */
  public float getX() {
    return this.x;
  }

  /**
   Return y coordinate of enemy
   */
  public float getY() {
    return this.y;
  }
}
