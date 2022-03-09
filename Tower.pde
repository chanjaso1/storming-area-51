public class Tower {
  public int range, cost;
  public float damage;
  public int width, height;
  public float x, y;
  public String name;
  public Projectile projectile;
  public int muzzleFireCount = 0;
  private float angle;
  private boolean loaded = true, alternateFire = true;
  public Tower(String name) {
    if (name.equals("Machine Gunner")) {
      width = 60;
      height = 60;
      this.range = 100;
      this.cost = 40;
      this.damage = 0.5;
    } else if (name.equals("Rocket Launcher")) {
      width = 60;
      height = 60;
      this.range = 110;
      this.cost = 60;
      this.damage = 3.5;
    } else if (name.equals("Auto Launcher")) {
      width = 80;
      height = 80;
      this.range = 120;
      this.cost = 100;
      this.damage = 2;
    } else    return;
    this.name = name;
    this.x = mouseX;
    this.y = mouseY;
    projectile = new Projectile(name);
  }

  /**
   Return x coordinate of tower
   */
  public float getX() {
    return this.x;
  }

  /**
   Return y coordinate of tower
   */
  public float getY() {
    return this.y;
  }

  /**
   Get cost of tower
   */
  public int getCost() {
    return cost;
  }

  /**
   Return name of the tower
   */
  public String getName() {
    return name;
  }

  /**
   Return name of the tower
   */
  public int getWidth() {
    return width;
  }

  /**
   Return name of the tower
   */
  public int getHeight() {
    return height;
  }

  /**
   Get damage of tower
   */
  public float getDamage() {
    return damage;
  }

  public int getRange() {
    return range;
  }

  /**
   Spend money on tower
   */
  public void buy() {
    money -= cost;
    totalSpent += cost;
  }

  /**
   Draw the tower and all of its actions (rotating, firing)
   */
  public void drawTower() {
    fill(0, 255, 0);
    stroke(0);
    strokeWeight(1);
    translate(x, y);

    if (name.equals("Machine Gunner")) {
      image(turretFloor, 0-width/2, 0-height/2, 60, 60);
    } else if (name.equals("Rocket Launcher")) {
      image(turretFloor2, 0-width/2, 0-height/2, 60, 60);
    } else if (name.equals("Auto Launcher")) { 
      image(turretFloor3, 0-width/2, 0-height/2, 80, 80);
    }

    rotate(angle);  //rotate tower head to face enemy 
    if (name.equals("Machine Gunner")) {
      image(machineGunHead, 0-width/2, 0-height/2, 60, 60);
    } else if (name.equals("Rocket Launcher")) {
      if (loaded)  image(rocketHeadLoaded, 0-width/2, 0-height/2, 60, 60);
      else         image(rocketHead, 0-width/2, 0-height/2, 60, 60);
    } else if (name.equals("Auto Launcher")) { 
      image(autoLauncher, 0-width/2, 0-height/2, 80, 80);
    }
    fill(100, 100, 100, 127);
    noStroke();
    stroke(0);
    resetMatrix();
    for (Enemy enemy : enemies) {   
      if (dist(enemy.getX(), enemy.getY(), x, y) <= range) {      //if enemy is in range
        angle = atan2(enemy.getY() - y, enemy.getX() - x) + PI/2;
        translate(x, y);        
        rotate(angle);
        if (!pause) {
          if (getName().equals("Machine Gunner")) {
            if (muzzleFireCount % 15 == 0)  image(muzzleFire, -30, -65, 60, 60);    //muzzle fire from the machine gun turret
            muzzleFireCount++;
          } else if (getName().equals(("Auto Launcher"))) {
            if (muzzleFireCount % 20 == 0) {
              if (alternateFire)       image(muzzleFire, -30, -90, 80, 80);
              else if (!alternateFire) image(muzzleFire, -50, -90, 80, 80);     
              muzzleFireCount++;
              alternateFire = !alternateFire;    //alternate muzzle fire from each barrel
            }
          } else loaded = true;
        }
        resetMatrix();
        loaded = false;
        if (!pause) projectile.shoot(this, enemy);
        break;                                    //only fire at one enemy at a time
      } else loaded = true;
    }
  }
}
