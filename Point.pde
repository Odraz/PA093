class Point{
  float WIDTH = 20;
  float x, y;
  
  Point(float x, float y){
   this.x = x;
   this.y = y; 
  }
  
  void display(){
    noStroke();
    fill(255);
    ellipse(x, y, WIDTH, WIDTH);
  }
}