public class Projectile {
  private float a;
  private float speed;
  public Projectile(String name) {
    if (name == "Machine Gunner") {
      this.speed = 0.08;
      this.a = 0.3;
    } else if (name.equals("Rocket Launcher")) {
      this.speed = 0.03;
      this.a = 0;
    } else if (name.equals("Auto Launcher")) {
      this.speed = 0.04;
      this.a = 0.1;
    }
  }

  /**
   Shooting from tower to enemy
   Bullet follows a bezier path
   */
  public void shoot(Tower t, Enemy e) {

    float x1 = t.getX(), y1 = t.getY();
    float x2 = e.getX(), y2 = e.getY();

    stroke(0);
    noFill();
    strokeWeight(1);
    float x = bezierPoint(x1, x1, x2, x2, a);
    float y = bezierPoint(y1, y1, y2, y2, a);
    noStroke();
    fill(255, 0, 0);
    translate(x, y) ;

    float xTangent = bezierTangent(x1, x2, x2, x2, a);
    float yTangent = bezierTangent(y1, y2, y2, y2, a);
    float angle = atan2( yTangent, xTangent ) ;
    rotate(angle-30) ;          //rotate projectile so it faces towards the target

    if (t.getName().equals("Rocket Launcher")) {
      image(rocket, -30, -30);      //draw rocket
    }

    a += speed ;
    if ( a>1.0 ) {  //when the projectile hits the enemy 
      a=0.0;  //reset for next shot
      e.hit(t.getDamage());
      if (t.getName().equals("Auto Launcher")) {
        for (int i = 0; i < enemies.size(); i++) { 
          float targetX = enemies.get(i).getX();
          float targetY = enemies.get(i).getY();
          if (dist(x2, y2, targetX, targetY) <= 60)  enemies.get(i).hit(t.getDamage()/2);  //splash damage on nearby enemies
        }
      }
      
      frames = (frames+1) % images;  // Use % to cycle through frames
      int iterate = 0;
      for (int i = -100; i < width; i += image[0].width*3) { 
        if (t.getName().equals("Auto Launcher")) {
          image(image[(frames+iterate/1000) % images], -random(0, 30), random(-30, 30));
        } else if (t.getName().equals("Rocket Launcher")) {
          image(image[(frames+iterate/1000) % images], -30, -30);
        }
        iterate++;
      }
    }
    resetMatrix();
  }
}
